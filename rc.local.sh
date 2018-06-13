#!/bin/sh -e

# Wait for the TV-screen to be turned on...
while ! $( tvservice --dumpedid /tmp/edid | fgrep -qv 'Nothing written!' ); do
	bHadToWaitForScreen=true;
	printf "===> Screen is not connected, off or in an unknown mode, waiting for it to become available...\n"
	sleep 10;
done;

printf "===> Screen is on, extracting preferred mode...\n"
_DEPTH=32;
_XRES=1080
_YRES=1920
_GROUP=CEA
_MODE=16

#eval $( edidparser /tmp/edid | fgrep 'preferred mode' | tail -1 | sed -Ene 's/^.+(DMT|CEA) \(([0-9]+)\) ([0-9]+)x([0-9]+)[pi]? @.+/_GROUP=\1;_MODE=\2;_XRES=\3;_YRES=\4;/p' );
#printf "===> Resetting screen to preferred mode: %s-%d (%dx%dx%d)...\n" $_GROUP $_MODE $_XRES $_YRES $_DEPTH
tvservice --explicit="$_GROUP $_MODE"
sleep 1;

printf "===> Resetting frame-buffer to %dx%dx%d...\n" $_XRES $_YRES $_DEPTH
fbset --all --geometry $_XRES $_YRES $_XRES $_YRES $_DEPTH -left 0 -right 0 -upper 0 -lower 0;
sleep 1;

echo "===> Ethernet going down."
ifdown eth0
ifconfig eth0 10.0.2.1 netmask 255.255.255.0

echo "===> Configuring ethernet forwarding..."
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

if [ -f /boot/xinitrc ]; then
	echo "===> Linking xinitrc and starting X...";
	ln -fs /boot/xinitrc /home/pi/.xinitrc;
	su - pi -c 'startx' &
fi

exit 0
