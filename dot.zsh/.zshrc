export EDITOR='vim'
export GREP_OPTIONS='--color=auto -r -I'
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export BROWSER='google-chrome'

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# PROMPT
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' formats '(%b)'
zstyle ':vcs_info:*' actionformats '(%b|%a)'
setopt transient_rprompt

precmd() {
  psvar=()
  vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  [[ -s $HOME/bin/rvm-prompt ]] && psvar[2]=`rvm-prompt`
  [[ -e $PWD/.git/refs/stash ]] && psvar[3]="$(git stash list 2>/dev/null | wc -l) stashed"
}
PROMPT=$'%B%F{green}%n@%m%f %F{blue}%~%f%b %1(V|%F{green}%1v%3(V| - %3v|)%f |)%2(V|%F{red}(%2v%)%f|)\n%B%F{blue}$%f%b '
SPROMPT="correct: %R -> %r ? "

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

# complement
fpath=($HOME/.zsh/functions $HOME/.zsh/zsh-completions $fpath)
autoload -U compinit promptinit
compinit
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' use-cache 1
setopt list_packed

autoload cdd; cdd > /dev/null

# Ctrl-D
set IGNORE_EOF

alias v='vim'
alias g='git'

alias ls='ls -F --color=auto'
alias ll='ls -alh'
alias la='ls -a'
alias apt='sudo aptitude'

alias reload='source $ZDOTDIR/.zshrc'

alias be='bundle exec'

alias -g L="| $PAGER"
alias -g G="| grep"

setopt auto_cd
setopt auto_pushd
setopt correct
setopt extended_history
setopt share_history

stty stop undef

bindkey -e

function chpwd() {
  ls
  _reg_pwd_screennum
}

# node.js
export NODE_PATH=$HOME/.npm/libraries:$NODE_PATH
export PATH=$HOME/.npm/bin:$PATH
export MANPATH=$HOME/.npm/man:$MANPATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
