#!/bin/sh
IFACE=en0
MAC=cc:20:e8:69:cd:f5

sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z 
sudo /sbin/ifconfig $IFACE lladdr $MAC
sudo /usr/sbin/networksetup -detectnewhardware
sudo /sbin/ifconfig $IFACE up
