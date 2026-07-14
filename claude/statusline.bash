#!/usr/bin/env bash
input=$(cat)

IFS=$'\t' read -r cwd model ctx_pct ctx_tokens ctx_size rl_5h rl_5h_resets rl_7d rl_7d_resets < <(
  echo "$input" | jq -r '[
    .workspace.current_dir,
    .model.display_name,
    (.context_window.used_percentage // ""),
    (.context_window.current_usage.input_tokens // ""),
    (.context_window.context_window_size // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.rate_limits.seven_day.resets_at // "")
  ] | @tsv'
)

dir() {
  if [ "$cwd" = "$HOME" ]; then echo "~"
  else basename "$cwd"
  fi
}

context() {
  [ -n "$ctx_pct" ] && printf 'ctx:%d%%' "${ctx_pct%.*}"
}

rl_part() {
  local pct=$1 resets=$2 label=$3
  [ -z "$pct" ] && return
  printf '%s:%.0f%%' "$label" "$pct"
  if [ -n "$resets" ]; then
    # 7d reset: show MM/DD if not today, else HH:MM
    local today; today=$(date +%m/%d)
    local rst_date; rst_date=$(date -d "@$resets" +%m/%d)
    if [ "$rst_date" = "$today" ]; then
      printf '(→%s)' "$(date -d "@$resets" +%H:%M)"
    else
      printf '(→%s)' "$(date -d "@$resets" +'%m/%d')"
    fi
  fi
}

rate_limits() {
  local parts=()
  [ -n "$rl_5h" ] && parts+=("$(rl_part "$rl_5h" "$rl_5h_resets" "5h")")
  [ -n "$rl_7d" ] && parts+=("$(rl_part "$rl_7d" "$rl_7d_resets" "7d")")
  [ ${#parts[@]} -gt 0 ] && printf '%s' "${parts[*]}"
}

out="$(date +%H:%M) $(dir)"
ctx="$(context)"
rl="$(rate_limits)"
[ -n "$model" ] && out+=" | $model"
[ -n "$ctx" ] && out+=" | $ctx"
[ -n "$rl"  ] && out+=" | $rl"
printf '%s' "$out"
