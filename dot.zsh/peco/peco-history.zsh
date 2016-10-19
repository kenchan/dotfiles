# Search shell history with peco: https://github.com/peco/peco
# Adapted from: https://github.com/mooz/percol#zsh-history-search
if which peco &> /dev/null; then
  function peco_select_history() {
    BUFFER=$(fc -l -n 1 | tail -r | peco --query "$LBUFFER" --prompt "[history]")
    CURSOR=$#BUFFER # move cursor
    zle -R -c       # refresh
  }

  zle -N peco_select_history
  bindkey '^R' peco_select_history

  function peco_select_old_history() {
    BUFFER=$(tail -r ~/zsh_history.old | awk -F ';' '{print $2}' | peco --query "$LBUFFER" --prompt "[history]")
    CURSOR=$#BUFFER # move cursor
    zle -R -c       # refresh
  }

  zle -N peco_select_old_history
  bindkey '^S' peco_select_old_history
fi
