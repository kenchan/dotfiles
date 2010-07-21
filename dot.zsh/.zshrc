if [ ~/.profile ]; then
  source ~/.profile
fi

export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#export LS_COLORS='di=01;34:ln=32:ex=35'
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

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
  [[ -n "$rvm_ruby_string" ]] && psvar[2]="$rvm_ruby_string"
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
autoload -U compinit promptinit
compinit
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' use-cache 1
setopt list_packed

# Ctrl-D
set IGNORE_EOF

alias v='vim'
alias g='git'

alias ls='ls -F --color=auto'
alias ll='ls -alh'
alias la='ls -a'
alias apt='sudo aptitude'

#rubygems
export PATH=$HOME/.gem/ruby/1.8/bin:$PATH

setopt auto_cd
setopt auto_pushd
setopt correct
setopt extended_history
setopt share_history

# EDITOR
export EDITOR=vim
bindkey -e

function chpwd() { ls }


if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi
