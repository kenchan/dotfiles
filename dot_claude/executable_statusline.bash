#!/usr/bin/env bash
input=$(cat)

IFS=$'\t' read -r cwd model ctx_pct ctx_tokens ctx_size rl_5h rl_5h_resets rl_7d < <(
  echo "$input" | jq -r '[
    .workspace.current_dir,
    .model.display_name,
    (.context_window.used_percentage // ""),
    (.context_window.current_usage.input_tokens // ""),
    (.context_window.context_window_size // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // "")
  ] | @tsv'
)

dir() {
  if [ "$cwd" = "$HOME" ]; then
    echo "~"
  else
    basename "$cwd"
  fi
}

context() {
  if [ -n "$ctx_pct" ] && [ -n "$ctx_tokens" ] && [ -n "$ctx_size" ]; then
    printf ' ctx:%d%% %dk/%dk' "${ctx_pct%.*}" $((ctx_tokens / 1000)) $((ctx_size / 1000))
  elif [ -n "$ctx_pct" ]; then
    printf ' ctx:%d%%' "${ctx_pct%.*}"
  fi
}

reset_5h() {
  [ -z "$rl_5h_resets" ] && return
  printf ' ~%s' "$(date -d "@$rl_5h_resets" +%H:%M)"
}

rate_limits() {
  [ -n "$rl_5h" ] && printf ' 5h:%.0f%%' "$rl_5h" && reset_5h
  [ -n "$rl_7d" ] && printf ' 7d:%.0f%%' "$rl_7d"
}

printf '%s %s %s%s%s' \
  "[$(date +%H:%M:%S)]" \
  "$(dir)" \
  "$model" \
  "$(context)" \
  "$(rate_limits)"
