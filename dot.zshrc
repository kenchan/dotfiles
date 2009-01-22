# Created by newuser for 4.3.2

# PROMPT
PROMPT="%n@%m%% "
RPROMPT="[%~]"
SPROMPT="correct: %R -> %r ? "

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

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

# cd => ls
function chpwd() { ls }

# EDITOR
export EDITOR=vi
bindkey -e

# For Git
case "${OSTYPE}" in
  linux*)
  export GIT_PAGER="less -RE"
  ;;
esac
