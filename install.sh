#!/bin/bash
NETWORK_SSID=""
NETWORK_PASS=""
DHCP="dhcp"
DEPS="matchbox chromium-browser x11-xserver-utils ttf-mscorefonts-installer xwit sqlite3 libnss3 libgtk-3-0"
XORG="xserver-xorg xserver-xorg-video-fbdev xinit pciutils xinput xfonts-100dpi xfonts-75dpi xfonts-scalable"

echo "Copying xinitrc, config.txt, and interfaces..."
cp xinitrc ../
cp config.txt ../
cp interfaces.$DHCP /etc/network/interfaces.d/interfaces

echo "./boot/scripts/rc.local.sh" | sudo tee -a /etc/rc.local > /dev/null

echo "Generating the secure wifi configuration"
wpa_passphrase "$NETWORK_SSID" "$NETWORK_PASS" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y install $XORG $DEPS --fix-missing
apt autoremove
