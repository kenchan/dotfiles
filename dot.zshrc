if [ ~/.profile ]; then
  source ~/.profile
fi

# PROMPT
PROMPT="%m%% "
SPROMPT="correct: %R -> %r ? "

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%b)'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd() {
  psvar=()
  vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f[%~]|[%~])"

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
alias ll='ls -alh --color=auto'
alias la='ls -a --color=auto'
alias vi='vim'
alias apt='sudo aptitude'
alias g='git'

# for ruby
export LOCAL_GEM_HOME=/home/kenichi/.gem/ruby/1.8
export PATH=$PATH:$LOCAL_GEM_HOME/bin

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


if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi
