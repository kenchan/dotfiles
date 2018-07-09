alias git hub
alias g git
alias less 'less -R'
alias be 'bundle exec'

set -gx GOPATH $HOME

set -gx PATH $GOPATH/bin $PATH

set -gx EDITOR vim

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx SHELL (which fish)

set -g fish_prompt_pwd_dir_length 0

function fish_user_key_bindings
  bind \cr 'peco_select_history'
  bind \co 'peco_select_ghq_repository'
end

set -g fish_user_paths "/usr/local/opt/mysql@5.6/bin" $fish_user_paths
eval (direnv hook fish)

set -gx XDG_CONFIG_HOME $HOME/.config
