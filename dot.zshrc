# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(bundler autojump cap git go gnu-utils heroku knife rails rake rbenv ruby thor tmux brew)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
#

export TERM='xterm-256color'

_Z_CMD=j
case "$(uname)" in
  Darwin)
    . `brew --prefix`/etc/profile.d/z.sh
    ;;
  *)
    . /usr/share/z/z.sh
    ;;
esac

autoload -Uz zmv
unsetopt correct_all

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^o" history-beginning-search-backward-end

alias -g G="| grep"
alias zmv='noglob zmv -W'
alias git='hub'
alias -g P="| peco"
alias gho='cd $(ghq list -p P)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}("
PROMPT=$'%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n) %{$fg_bold[blue]%}%(!.%1~.%~)%{$reset_color%} $(git_prompt_info)%{$fg[red]%}[$(rbenv version-name)]%{$reset_color%}\n%{$fg_bold[blue]%}$%{$reset_color%} '

eval "$(rbenv init -)"

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
export PYENV_ROOT=/usr/local/opt/pyenv

export GOPATH=$HOME
export PATH=./bin:$HOME/bin:$GOPATH/bin:$HOME/.npm/node_module/bin:$PATH
compdef hub=git

function zman() {
  PAGER="less -g -s '+/^ {7}"$1"'" man zshall
}

function ghi() {
  [ "$#" -eq 0 ] && echo "Usage : gpi QUERY" && return 1
  ghs "$@" | peco | awk '{print $1}' | ghq import
}

[[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fpath=($HOME/.zsh/completions(N-/) $fpath)

autoload -Uz compinit
compinit
