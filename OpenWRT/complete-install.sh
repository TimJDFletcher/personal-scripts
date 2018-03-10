#!/bin/sh
packages="vim openvpn rsync empty mjpg-streamer bmon tc ip"
modules="iptables-mod-conntrack-extra kmod-leds-wndr3700-usb kmod-video-uvc"
services="openvpn mjpg-streamer"

if [ -f /.install.completed ] ; then
	echo Install already completed
	exit 0
fi

opkg update
opkg install $modules
opkg install $packages

for service in $services ; do 
	/etc/init.d/$service enable
	/etc/init.d/$service start
done

/etc/init.d/firewall restart

touch /.install.completed
