bindkey -e

# prompt
autoload -U colors && colors
autoload -U add-zsh-hook
autoload -U vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' formats '[%b]%c%u'
zstyle ':vcs_info:*' actionformats '[%b|%a]%c%u'
zstyle ':vcs_info:git:*' check-for-changes true

function _update_prompt() {
  LANG=en_US.UTF-8 vcs_info
  PROMPT="%{$fg[magenta]%}[%T]%{$reset_color%} %{$fg_bold[blue]%}%~ %{$fg[red]%}($(rbenv version-name)) %{$fg[green]%}${vcs_info_msg_0_}
%{$fg_bold[blue]%}$%{$reset_color%} "
}

add-zsh-hook precmd _update_prompt

# aliases
alias -g G="| grep"
alias zmv='noglob zmv -W'
alias git='hub'
alias -g P="| peco"
alias g='git'
alias ls='ls -GF'
alias la='ls -aGF'
alias ll='ls -alGF'

# x-env
eval "$(rbenv init -)"

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PYENV_ROOT=/usr/local/opt/pyenv

eval "$(direnv hook zsh)"

# golang
export GOPATH=$HOME

# peco
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-src
bindkey '^o' peco-src

# Search shell history with peco: https://github.com/peco/peco
# Adapted from: https://github.com/mooz/percol#zsh-history-search
if which peco &> /dev/null; then
  function peco_select_history() {
    local tac
    (which gtac &> /dev/null && tac="gtac") || \
      (which tac &> /dev/null && tac="tac") || \
      tac="tail -r"
    BUFFER=$(fc -l -n 1 | eval $tac | \
                peco --layout=bottom-up --query "$LBUFFER")
    CURSOR=$#BUFFER # move cursor
    zle -R -c       # refresh
  }

  zle -N peco_select_history
  bindkey '^R' peco_select_history
fi

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# misc
export TERM='xterm-256color'

autoload -Uz zmv
unsetopt correct_all

export PATH=./bin:$HOME/bin:$GOPATH/bin:$HOME/.npm/node_module/bin:$PATH

function zman() {
  PAGER="less -g -s '+/^ {7}"$1"'" man zshall
}

function ghi() {
  [ "$#" -eq 0 ] && echo "Usage : gpi QUERY" && return 1
  ghs "$@" | peco | awk '{print $1}' | ghq import
}

fpath=(/usr/local/share/zsh-completions $fpath)
fpath=($HOME/.zsh/completions(N-/) $fpath)

autoload -Uz compinit && compinit

if [ -f ~/.zsh/homebrew_search_token ];then
  source ~/.zsh/homebrew_search_token
fi
