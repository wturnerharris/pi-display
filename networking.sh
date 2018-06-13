#!/bin/bash

echo "===> Ethernet going down."
sudo ifdown eth0 && sudo ifconfig eth0 10.0.2.1 netmask 255.255.255.0
echo "===> Configuring ethernet forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1 && sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
