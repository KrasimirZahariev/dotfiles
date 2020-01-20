#!/bin/sh
wal -R &
compton -b &
dunst &
poly-launch &
setxkbmap us,bg -variant ,phonetic -option 'grp:lalt_lshift_toggle'
xset r rate 400 40
redshift -PO 3500

exec i3
