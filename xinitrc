#!/bin/sh

APP_URL="https://dev-barrel.pantheonsite.io/sweetboard/"

while true; do

	# Clean up previously running apps, gracefully at first then harshly
	killall -TERM chromium-browser 2>/dev/null;
	killall -TERM python 2>/dev/null;
	killall -TERM matchbox-window-manager 2>/dev/null;
	echo "Chrome and Matchbox terminated";
	sleep 2;

	killall -9 chromium-browser 2>/dev/null;
	killall -9 python 2>/dev/null;
	killall -9 matchbox-window-manager 2>/dev/null;
	echo "Final termination of Chrome and Matchbox";

	# Clean out existing profile information
	echo "Removing old pi config...";
	rm -rf /home/pi/.cache;
	rm -rf /home/pi/.config;
	rm -rf /home/pi/.pki;

	# Generate the bare minimum to keep Chromium happy!
	echo "Generating Chomium config...";
	mkdir -p /home/pi/.config/chromium/Default
	sqlite3 /home/pi/.config/chromium/Default/Web\ Data "CREATE TABLE meta(key LONGVARCHAR NOT NULL UNIQUE PRIMARY KEY, value LONGVARCHAR); INSERT INTO meta VALUES('version','46'); CREATE TABLE keywords (foo INTEGER);";

	# Disable DPMS / Screen blanking
	echo "Starting xset with opts...";
	xset s off
	xset -dpms
	xset s noblank

	# Reset the framebuffer's colour-depth
	echo "Resetting the framebuffer's depth...";
	fbset -depth $( cat /sys/module/*fb*/parameters/fbdepth );

	# Hide the cursor (move it to the bottom-right, comment out if you want mouse interaction)
	echo "Moving cursor to bottom right...";
	xwit -root -warp $( cat /sys/module/*fb*/parameters/fbwidth ) $( cat /sys/module/*fb*/parameters/fbheight )

	# Start the window manager (remove "-use_cursor no" if you actually want mouse interaction)
	echo "Starting matchbox...";
	matchbox-window-manager -use_titlebar no -use_cursor no &

	# Start the browser (See http://peter.sh/experiments/chromium-command-line-switches/)
	echo "Starting chromium...";
	chromium-browser --app=$APP_URL
done;
