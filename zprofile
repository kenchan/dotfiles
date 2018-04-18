unset RUBYOPT

if which keychain > /dev/null; then
  keychain id_rsa
  source $HOME/.keychain/$HOST-sh
fi

export EDITOR=vim
