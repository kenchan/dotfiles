# config.fish の mise activate より先に Homebrew の mise を PATH に載せる
if test -x /opt/homebrew/bin/brew
  /opt/homebrew/bin/brew shellenv fish | source
end

set -l op_agent_sock ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
if test -S $op_agent_sock
  set -gx SSH_AUTH_SOCK $op_agent_sock
end
