# conf.d は config.fish の mise activate より先に読まれ、mise で入れた
# wsl2-ssh-agent はまだ PATH に無いので mise which で探す
if status is-login; and command -vq mise
  set -l agent (mise which wsl2-ssh-agent 2>/dev/null)
  and $agent -format fish | source
end

if test -d "/mnt/c/Program Files/Oracle/VirtualBox"
  set -x PATH "/mnt/c/Program Files/Oracle/VirtualBox" $PATH
  set -x VAGRANT_WSL_ENABLE_WINDOWS_ACCESS 1
end

# WSL では Claude in Chrome を常に使う(functions/claude.fish も --chrome を付ける)
abbr -a c "claude --chrome"
abbr -a cc "claude --chrome -c || claude --chrome"
