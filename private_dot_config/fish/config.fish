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
abbr -a kx kubectx
abbr -a ks kubens
abbr -a tf terraform
abbr -a rge rg -E euc-jp
abbr -a e "code (ghq list -p | fzf)"
abbr -a c "claude -c || claude"
abbr -a z zellij

set -gx EDITOR nvim

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx SHELL (which fish)

set -g fish_prompt_pwd_dir_length 0

set -gx DOCKER_BUILDKIT 1

set -gx ASDF_RUBY_BUILD_VERSION master

set -x GPG_TTY (tty)

set -x FZF_DEFAULT_OPTS "--reverse --height 40%"

if command -v direnv > /dev/null;
  eval (direnv hook fish)
end

if command -v mise > /dev/null;
  mise activate fish | source
  mise hook-env -s fish | source
  mise complete -s fish | source
end

if command -vq wsl2-ssh-agent and is-login
  wsl2-ssh-agent | source
end

if [ -d $HOME/.local/bin ]
  set -gx PATH ~/.local/bin $PATH
end

if command -v starship > /dev/null;
  eval (starship init fish)
end

if command -v keychain > /dev/null;
  eval (keychain --eval --nogui -q ~/.ssh/id_ed25519)
end

if test -d "/mnt/c/Program Files/Oracle/VirtualBox"
  set -x PATH "/mnt/c/Program Files/Oracle/VirtualBox" $PATH
  set -x VAGRANT_WSL_ENABLE_WINDOWS_ACCESS 1
end

# moonbit
fish_add_path "$HOME/.moon/bin"
