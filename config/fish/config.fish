alias less 'less -R'

if command -v hub > /dev/null;
  alias git hub
end

if command -v lsd > /dev/null;
  alias ls 'lsd --icon never'
end

if command -v nvim > /dev/null;
  alias vim nvim
end

abbr -a b bundle
abbr -a be bundle exec
abbr -a d docker
abbr -a dc docker compose
abbr -a dce docker compose exec
abbr -a dcr docker compose run --rm
abbr -a g git
abbr -a k kubectl

if [ -d $HOME/.local/bin ]
  set -gx PATH ~/.local/bin $PATH
end

set -gx EDITOR nvim

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx SHELL (which fish)

set -g fish_prompt_pwd_dir_length 0

set -gx DOCKER_BUILDKIT 1

set -g GHQ_SELECTOR peco

set -gx ASDF_RUBY_BUILD_VERSION master

set -x GPG_TTY (tty)

if command -v direnv > /dev/null;
  eval (direnv hook fish)
end

if test -f ~/.asdf/asdf.fish
  source ~/.asdf/asdf.fish
end

if command -v starship > /dev/null;
  eval (starship init fish)
end

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
end

if command -v keychain > /dev/null;
  eval (keychain --eval --nogui -q ~/.ssh/id_ed25519)
end
