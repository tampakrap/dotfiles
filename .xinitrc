#!/bin/bash
xrdb -merge ~/.Xresources
xcompmgr &
setxkbmap 'us,gr,cz' -model mac -option -option 'grp:lalt_toggle' &
urxvtd-256color -q -o -f
sh ~/.fehbg &
xset s 180 180
syndaemon -t -k -i 2 -d
exec /usr/bin/i3
