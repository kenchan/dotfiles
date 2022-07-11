function __history_and_frgm
  history;

  if command -v -q frgm
    frgm list --format ":content # :name [frgm :group :labels]"
  end
end

function peco_select_history_and_frgm
  if test (count $argv) = 0
    set peco_flags --layout=bottom-up
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  __history_and_frgm | peco $peco_flags | read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end
