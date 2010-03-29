#!/bin/sh

export LANG=ja_JP.UTF-8
export GTK_IM_MODULE=uim
export XMODIFIRES=@im=uim

xmodmap $HOME/.Xmodmap
xscreensaver -no-splash &
dropboxd &
exec awesome
