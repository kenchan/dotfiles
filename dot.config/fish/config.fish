alias git hub
alias g git

set -gx GOPAHT $HOME

set -gx PATH $GOPATH/bin $PATH

set -g fish_prompt_pwd_dir_length 0

function fish_user_key_bindings
  bind \cr 'peco_select_history'
  bind \co 'peco_select_ghq_repository'
end
