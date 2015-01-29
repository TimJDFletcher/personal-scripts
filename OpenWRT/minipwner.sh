#!/bin/sh
if [ -f /.install.minipwner ] ; then
	echo Minipwner already installed
	exit 0
fi

packages="rsync nano bmon netcat tar openssh-sftp-client nmap tcpdump 
aircrack-ng kismet-client kismet-server perl openvpn nbtscan snort karma 
samba36-client elinks yafc ip"

/etc/init.d/dnsmasq stop

opkg update
opkg install $packages

/etc/init.d/dnsmasq disable
/etc/init.d/dnsmasq stop

touch /.install.minipwner

