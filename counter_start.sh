#!/usr/bin/env zsh
killall -SIGSTOP i3
urxvt -geometry 100x2 -name "flub" -e tmux -L CNTR&
sleep 0.5
ID=0x`xwininfo -root -tree | grep "flub" | sed -e 's/^ *0x//' -e 's/ .*//'`
SCRNWDT=`xrandr | grep \* | sed -e 's/x.*//' -e 's/^ *//'`
xprop -id $ID -f _NET_WM_STRUT_PARTIAL 32cccccccccccc -set _NET_WM_STRUT_PARTIAL "0, 0, 0, 42, 0, 0, 0, 0, 0, 0, 0, $SCRNWDT"
xprop -id $ID -f _NET_WM_WINDOW_TYPE 32a -set _NET_WM_WINDOW_TYPE _NET_WM_WINDOW_TYPE_DOCK
killall -SIGCONT i3
sleep 0.5
tmux -L CNTR send-keys 'countup-bin $COLUMNS 60' "Enter"
tmux -L CNTR set-option -g status off
