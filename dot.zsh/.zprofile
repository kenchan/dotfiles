unset RUBYOPT
export PATH=$HOME/bin:$HOME/.gem/ruby/1.8/bin:$PATH:/usr/local/sbin:/usr/sbin:/sbin
if which keychain > /dev/null; then
  keychain id_rsa
  source $HOME/.keychain/$HOST-sh
fi
