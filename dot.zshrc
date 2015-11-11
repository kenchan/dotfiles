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
alias be='bundle exec'

# x-env
eval "$(rbenv init -)"

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PYENV_ROOT=/usr/local/opt/pyenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

eval "$(direnv hook zsh)"

# golang
export GOPATH=$HOME

# peco
export GHQ="/usr/local/bin/ghq"
export GIT="/usr/local/bin/git"

function ghq() {
  case $1 in
    get )
      $GHQ $@

      # hook after ghq get
      (ghq-cache update &)
      ;;
    list )
      if [ ! -e ~/.ghq-cache ]; then
        ghq-cache update
      fi

      # use ghq list ordered by ghq-cache
      cat ~/.ghq-cache
      ;;
    * )
      $GHQ $@
      ;;
  esac
}

function git() {
    case $1 in
        init )
            $GIT $@
            (ghq-cache update &)
            ;;
        clone )
            $GIT $@
            (ghq-cache update &)
            ;;
        * )
            $GIT $@
            ;;
    esac
}

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
stty -ixon
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
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

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
