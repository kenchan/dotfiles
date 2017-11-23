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
if [[ -s ~/.zsh/aliases ]] then
  source ~/.zsh/aliases
fi

# x-env
eval "$(rbenv init -)"

eval "$(direnv hook zsh)"

if [[ -d ~/.venv/python3 ]] then
  source ~/.venv/python3/bin/activate
fi

# golang
export GOPATH=$HOME

stty -ixon

if which peco &> /dev/null; then
  for f (~/.zsh/peco/*) source "${f}"
fi

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=500000000000000
export SAVEHIST=$HISTSIZE

setopt extended_history
setopt hist_ignore_all_dups
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

fpath=(/usr/local/share/zsh-completions $fpath)
fpath=($HOME/.zsh/functions $HOME/.zsh/completions(N-/) $fpath)

autoload -Uz compinit && compinit

if [ -f ~/.config/homebrew/search_token ];then
  source ~/.config/homebrew/search_token
fi

# added by travis gem
[ -f /Users/kenchan/.travis/travis.sh ] && source /Users/kenchan/.travis/travis.sh

## cdd
if [[ -s ~/.zsh/scripts/cdd ]] then
  source ~/.zsh/scripts/cdd
  function chpwd() {
    _cdd_chpwd
  }
fi

## ruby 2.3.0
export RUBYOPTS=-ryomikomu
