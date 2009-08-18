#!/bin/sh

export LANG=ja_JP.UTF-8
export GTK_IM_MODULE=uim
export XMODIFIERS=@im=uim

xmodmap $HOME/.Xmodmap

if which xscreensaver > /dev/null 2>&1; then
  xscreensaver -no-splash &
fi

if test -x $HOME/.dropbox-dist/dropboxd; then
  $HOME/.dropbox-dist/dropboxd &
fi

if which wakoopa > /dev/null 2>&1; then
  wakoopa &
fi
