set -q herdr_space_tint_strength; or set -g herdr_space_tint_strength 0.5

function herdr_space_tint --description 'herdr の space ごとにペイン背景を色分けする'
  set -q HERDR_WORKSPACE_ID; or return
  set -l name (herdr workspace get $HERDR_WORKSPACE_ID 2>/dev/null | jq -r '.result.workspace.label // empty' 2>/dev/null)
  if test -z "$name" -o "$name" = '~'
    herdr_space_tint_reset
    return
  end
  set -l hues \
    "36 0 0" "34 11 0" "32 21 0" "30 30 0" "20 30 0" "10 30 0" \
    "0 30 0" "0 30 10" "0 30 20" "0 30 30" "0 21 32" "0 11 34" \
    "0 0 36" "12 0 36" "24 0 36" "36 0 36" "36 0 24" "36 0 12"
  set -l delta (string split ' ' $hues[(math 1 + 0x(printf %s $name | md5sum | string sub -l 8) % (count $hues))])
  printf '\e]11;#%02x%02x%02x\e\\' (for d in $delta; math -s0 "30 + $d * $herdr_space_tint_strength"; end)
end

function herdr_space_tint_reset --description 'ペイン背景をホスト端末の既定色に戻す'
  printf '\e]111\e\\'
end

function __herdr_space_tint_startup --on-event fish_prompt
  functions -e __herdr_space_tint_startup
  herdr_space_tint
end
