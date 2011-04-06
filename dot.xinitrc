#!/bin/sh

export LANG=ja_JP.UTF-8
export GTK_IM_MODULE=uim
export XMODIFIERS=@im=uim

xmodmap $HOME/.Xmodmap
uim-xim &
thunar --daemon &
xscreensaver -no-splash &
dropbox start &
textareaserver -c gvim &
dbus-launch gnome-do &
exec awesome
