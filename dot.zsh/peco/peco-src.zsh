bindkey '^o' peco-src

function peco-src() {
  local selected_dir=$(ghq list | peco --query "$LBUFFER" --prompt "[ghq list]")
  if [ -n "$selected_dir" ]; then
    full_dir="${GOPATH}/src/${selected_dir}"

    # Log repository access to ghq-cache
    (ghq-cache log $full_dir &)

    BUFFER="cd ${full_dir}"
    zle accept-line
  fi
  zle redisplay
}
zle -N peco-src
