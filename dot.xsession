#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for i in /etc/X11/xinit/xinitrc.d/* ; do
    if [ -x "$i" ]; then
      . "$i"
    fi
  done
fi

export LANG=ja_JP.UTF-8
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
export XMODIFIERS=@im=uim
export XIM_PROGRAM=uim-xim

xmodmap $HOME/.Xmodmap
xscreensaver -no-splash &
dropbox start &
textareaserver -c gvim &
gnome-do &
gnome-power-manager &
nm-applet &

exec awesome
