#!/bin/sh

export LANG=ja_JP.UTF-8
export GTK_IM_MODULE=uim
export XMODIFIRES=@im=uim

xmodmap $HOME/.Xmodmap
uim-xim &
thunar --daemon &
xscreensaver -no-splash &
dropboxd &
exec awesome
