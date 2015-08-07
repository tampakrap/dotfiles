#!/bin/sh

xrdb -merge ~/.Xresources
xcompmgr &
case $HOSTNAME in
    guru|virtuoso|xzibit) setxkbmap 'us,gr,cz' -option -option 'grp:lwin_toggle' ;;
    rakim)
        setxkbmap 'us,gr,cz' -model mac -option -option 'grp:lalt_toggle'
        xmodmap ~/.Xmodmap_mac
        ;;
esac
xmodmap ~/.Xmodmap
urxvtd-256color -q -o -f
sh ~/.fehbg &
xset s 180 180
case $HOSTNAME in guru|rakim|virtuoso) syndaemon -t -k -i 2 -d ;; esac
case $HOSTNAME in rakim|virtuoso)
    export LC_ALL="cs_CZ.UTF-8"
    export LANG="cs_CZ.UTF-8"
    ;;
esac
exec /usr/bin/i3
