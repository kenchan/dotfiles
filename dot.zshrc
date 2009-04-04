# PROMPT
PROMPT="%n@%m%% "
RPROMPT="[%~]"
RPROMPT_DEFAULT="[%~]"
SPROMPT="correct: %R -> %r ? "

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# complement
autoload -U compinit; compinit
setopt list_packed

# Ctrl-D
set IGNORE_EOF

# aliases
alias ls='ls -F --color=auto'
alias ll='ls -al --color=auto'
alias la='ls -a --color=auto'
alias vi='vim'
alias apt='sudo aptitude'
alias g='git'

# for ruby
export LOCAL_GEM_HOME=/home/kenichi/.gem/ruby/1.8
export PATH=$PATH:$LOCAL_GEM_HOME/bin

# for jruby
export JRUBY_HOME=/usr/local/jruby-1.1.5
export PATH=$PATH:$JRUBY_HOME/bin

setopt auto_cd
setopt auto_pushd
setopt correct
setopt extended_history
setopt share_history

# EDITOR
export EDITOR=vi
bindkey -e

# For Git
case "${OSTYPE}" in
  linux*)
  export GIT_PAGER="less -RE"
  ;;
esac

function chpwd() { ls }

typeset -ga chpwd_functions
typeset -ga preexec_functions

function _set_rprompt_git() {
  local git_branch
  git_branch="${$(git symbolic-ref HEAD 2> /dev/null)#refs/heads/}"
  if [ $? != '0' ]; then
    RPROMPT=$RPROMPT_DEFAULT
  else
    RPROMPT=' %{[32m%}('$git_branch')%{[00m%} '$RPROMPT_DEFAULT
  fi
}

chpwd_functions+=_set_rprompt_git
preexec_functions+=_set_rprompt_git
