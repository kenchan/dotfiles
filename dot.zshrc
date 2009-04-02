# Created by newuser for 4.3.2

# PROMPT
PROMPT="%n@%m%% "
RPROMPT_DEFAULT="[%~]"
SPROMPT="correct: %R -> %r ? "

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
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

typeset -ga chpwd_functions
function _screen_title_chpwd() {
  if [ "$TERM" = "screen" ]; then
    echo -n "^[k[`basename $PWD`]^[\\"
  fi
}
functions _set_rprompt_git() {
  local -A git_res
  git_res=`/usr/bin/git branch -a --no-color 2> /dev/null `
  if [ $? != '0' ]; then
    RPROMPT=$RPROMPT_DEFAULT
  else
    git_res=`echo $git_res|grep '^*'|tr -d '\* '`
    RPROMPT=' %{[32m%}('$git_res')%{[00m%} '$RPROMPT_DEFAULT
  fi
}
functions _xxx_ls() {
  ls
}
chpwd_functions+=_xxx_ls
chpwd_functions+=_screen_title_chpwd
chpwd_functions+=_reg_pwd_screennum
chpwd_functions+=_set_rprompt_git

