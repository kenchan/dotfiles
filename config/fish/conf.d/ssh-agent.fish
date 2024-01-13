# Configure ssh forwarding
set -x SSH_AUTH_SOCK $HOME/.ssh/agent.sock
# Check if npiperelay and socat are available
if not command -v npiperelay.exe >/dev/null
    echo "npiperelay is not installed. Exiting."
    exit 1
end

if not command -v socat >/dev/null
    echo "socat is not installed. Exiting."
    exit 1
end

# Check if the relay is already running
set ALREADY_RUNNING (ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $status)
if test $ALREADY_RUNNING -ne 0
    if test -S $SSH_AUTH_SOCK
        echo "removing previous socket..."
        rm $SSH_AUTH_SOCK
    end
    echo "Starting SSH-Agent relay..."
    # Run socat in background to forward SSH_AUTH_SOCK to npiperelay

    # Run socat in background to forward SSH_AUTH_SOCK to npiperelay
    socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork 'EXEC:npiperelay.exe -ei -s //./pipe/openssh-ssh-agent' >/dev/null 2>&1 &
    #    socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork 'EXEC:npiperelay.exe -ei -s //./pipe/openssh-ssh-agent' >/dev/null ^/dev/null &
end
