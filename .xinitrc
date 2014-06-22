#!/bin/bash
xrdb -merge ~/.Xresources
xcompmgr &
setxkbmap 'us,gr' -model mac -option -option 'grp:lalt_toggle' &
urxvtd-256color -q -o -f
sh ~/.fehbg &
exec /usr/bin/i3
