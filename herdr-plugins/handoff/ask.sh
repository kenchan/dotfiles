#!/usr/bin/env bash
set -euo pipefail

# popup は pane ではないので、呼び出し元は context JSON から取る
ctx="${HERDR_PLUGIN_CONTEXT_JSON:-}"
[ -n "$ctx" ] || ctx="{}"
from_ws=$(jq -r '.workspace_label // empty' <<<"$ctx" 2>/dev/null || true)
from_cwd=$(jq -r '.focused_pane_cwd // empty' <<<"$ctx" 2>/dev/null || true)

echo "これから何やる？（空で Enter するとキャンセル）"
read -re -p "> " task
[ -n "$task" ] || exit 0

log_dir="${HERDR_PLUGIN_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/herdr-handoff}/logs"
mkdir -p "$log_dir"
log="$log_dir/$(date +%Y%m%d-%H%M%S).log"

# popup が閉じるとプロセスグループごと止められるので、別セッションに切り離す（macOS には setsid コマンドが無い）
echo "context: $ctx" >"$log"
nohup perl -MPOSIX -e 'POSIX::setsid(); exec @ARGV' bash "$(dirname "$0")/dispatch.sh" "$task" "$from_ws" "$from_cwd" >>"$log" 2>&1 </dev/null &
echo "振り分け中（log: $log）"
sleep 1
