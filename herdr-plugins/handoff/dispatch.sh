#!/usr/bin/env bash
# 依頼を claude -p の /handoff スキル（claude/skills/handoff）に渡し、
# herdr のタブと作業者を立てさせる
set -uo pipefail

task="$1"
from_ws="${2:-}"
from_cwd="${3:-}"
herdr="${HERDR_BIN_PATH:-herdr}"

# 振り分けに要るのは herdr のタブ・作業者の操作と repo の場所探しだけ。
# herdr pane run などは任意のコマンド実行になるので許さない
allowed=(
  'Bash(herdr workspace list)'
  'Bash(herdr workspace list *)'
  'Bash(herdr workspace create *)'
  'Bash(herdr tab list *)'
  'Bash(herdr tab create *)'
  'Bash(herdr tab rename *)'
  'Bash(herdr agent list)'
  'Bash(herdr agent start *)'
  'Bash(herdr agent prompt *)'
  'Bash(ghq list)'
  'Bash(ghq list *)'
  'Bash(ghq get *)'
  'Bash(gh search repos *)'
  'Bash(jq *)'
  'Skill(handoff)'
)

# マシン固有の値（GitHub Enterprise Server のホストなど）は repo に置かず、git 管理外の設定から読む
config="${XDG_CONFIG_HOME:-$HOME/.config}/handoff/config.toml"
config_text="(no config)"
if [ -r "$config" ]; then
  config_text=$(cat "$config")
  # GH_HOST の前置はホストを固定して許す。任意の環境変数の前置を許すと何でも差し込める
  while read -r host; do
    [ -n "$host" ] && allowed+=("Bash(GH_HOST=$host gh search repos *)")
  done < <(perl -ne 'if (/^\s*gh_hosts\s*=\s*\[(.*)\]/) { print "$_\n" for $1 =~ /"([A-Za-z0-9.-]+)"/g }' "$config")
fi

prompt="/handoff ${task}

（handoff プラグインから。振り分け役として、タブと作業者を立てて依頼を渡すところまでで終わる。報告先なし。ファイルには書き込まない。呼び出し元: workspace ${from_ws:-不明}、cwd ${from_cwd:-不明}。これは cwd を決めるヒントで、行き先とは限らない）
このマシンの設定（${config}）:
${config_text}
最後の行に \"OK <workspace label> / <tab name> (<cwd>)\" か \"NG <理由>\" を書く。"

echo "request: $task"
echo "from: ${from_ws:-unknown} ${from_cwd:-}"

# cwd を HOME にして、呼び出し元 repo の CLAUDE.md・settings・hooks を効かせない
cd "$HOME"
out=$(claude -p "$prompt" \
  --model sonnet \
  --tools Bash,Skill \
  --permission-mode dontAsk \
  --permission-prompts none \
  --strict-mcp-config \
  --no-session-persistence \
  --allowedTools "${allowed[@]}" \
  --output-format json)
status=$?
echo "$out"

result=$(jq -r '.result // empty' <<<"$out" 2>/dev/null)
last=$(printf '%s\n' "$result" | grep -E '^(OK|NG) ' | tail -1)
if [ $status -eq 0 ] && [[ "$last" == OK* ]]; then
  "$herdr" notification show "handoff" --body "${last#OK }" --sound none >/dev/null 2>&1 || true
else
  "$herdr" notification show "handoff に失敗" --body "${last:-claude -p exit $status}（log を見る）" --sound request >/dev/null 2>&1 || true
  exit 1
fi
