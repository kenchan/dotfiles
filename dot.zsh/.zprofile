export PATH=$HOME/bin:$PATH:/usr/local/sbin:/usr/sbin:/sbin
if which keychain > /dev/null; then
  keychain id_rsa
  source $HOME/.keychain/$HOST-sh
fi
