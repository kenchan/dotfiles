alias git hub
alias less 'less -R'
alias ls exa

abbr -a b bundle
abbr -a be bundle exec
abbr -a d docker
abbr -a dc docker-compose
abbr -a dce docker-compose exec
abbr -a dcr docker-compose run --rm
abbr -a g git
abbr -a k kubectl

set -gx GOPATH $HOME

set -gx PATH $GOPATH/bin $PATH

set -gx EDITOR vim

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx SHELL (which fish)

set -g fish_prompt_pwd_dir_length 0

eval (direnv hook fish)

set -gx DOCKER_BUILDKIT 1

if command -v direnv > /dev/null;
  eval (direnv hook fish)
end
