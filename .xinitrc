#!/bin/sh

xrdb -merge ~/.Xresources
xcompmgr &
case $HOSTNAME in
    xzibit|virtuoso) setxkbmap 'us,gr,cz' -option -option 'grp:lwin_toggle' ;;
    rakim)
        setxkbmap 'us,gr,cz' -model mac -option -option 'grp:lalt_toggle'
        xmodmap ~/.Xmodmap_mac
        ;;
esac
xmodmap ~/.Xmodmap
urxvtd-256color -q -o -f
sh ~/.fehbg &
xset s 180 180
case $HOSTNAME in rakim|virtuoso) syndaemon -t -k -i 2 -d ;; esac
exec /usr/bin/i3
