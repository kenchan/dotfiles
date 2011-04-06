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
command=awesome
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for i in /etc/X11/xinit/xinitrc.d/* ; do
    if [ -x "$i" ]; then
      . "$i"
    fi
  done
fi
exec $command
