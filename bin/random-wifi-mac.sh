#!/bin/sh
IFACE=en0
MAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

echo Setting MAC address of ${IFACE} to ${MAC}

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z 
sudo /sbin/ifconfig $IFACE lladdr $MAC
sudo /usr/sbin/networksetup -detectnewhardware
sudo /sbin/ifconfig $IFACE up
