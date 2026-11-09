function claude --wraps claude --description 'claude with --chrome enabled by default'
    if contains -- --chrome $argv; or contains -- -p $argv; or contains -- --print $argv
        command claude $argv
    else
        command claude --chrome $argv
    end
end
