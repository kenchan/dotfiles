alias git hub
alias g git
alias less 'less -R'
alias be 'bundle exec'
alias ls exa

set -gx GOPATH $HOME

set -gx PATH $GOPATH/bin $PATH

set -gx EDITOR vim

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx SHELL (which fish)

set -g fish_prompt_pwd_dir_length 0

eval (direnv hook fish)

set -gx DOCKER_BUILDKIT 1

function fish_user_key_bindings
  bind \cg '__ghq_crtl_g'
end
