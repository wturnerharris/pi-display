#!/bin/bash

# set display
export DISPLAY=":0"

# set var to retrieve window id
WID=$(xdotool search --onlyvisible --class chromium|head -1)

# reload window according to cron schedule
if [ -n $WID ]; then 
	echo "===> Reloading Chromium..."
	echo "Reloading Chromium" | wall
	xdotool windowactivate $WID
	xdotool key ctrl+shift+r
else
	echo "No window to reload"
	echo "Chromium not reloaded" | wall
fi

exit 0
