#!/bin/ash          
cp -f /etc/config/network /etc/config/network.orig 
cp -f /etc/config/wireless /etc/config/wireless.orig
cp -f /etc/config/firewall /etc/config/firewall.orig
cp -f /etc/profile /etc/profile.orig
cp -f /etc/config/fstab /etc/config/fstab.orig
cp -f /etc/opkg.conf /etc/opkg.conf.orig
cp -f /etc/config/system /etc/config/system.orig
cp -f /etc/config/dhcp /etc/config/system.orig
cp -f ./network.1 /etc/config/network
cp -f ./wireless.1 /etc/config/wireless
cp -f firewall.1 /etc/config/firewall
/etc/init.d/network restart
wifi
sleep 8
opkg update
opkg install kmod-usb-storage
opkg install kmod-fs-ext4
opkg install block-mount
cp -f profile.1 /etc/profile
cp -f fstab.1 /etc/config/fstab
cp -f opkg.conf.1 /etc/opkg.conf
cp -f system.1 /etc/config/system
/etc/init.d/fstab enable
/etc/init.d/fstab start
sleep 1
mkdir /mnt/usb
ln -s /mnt/usb /opt
ln -s /etc /mnt/usb/etc
opkg install netcat
opkg -dest usb install tar
opkg -dest usb install openssh-sftp-client
opkg -dest usb install nmap
opkg -dest usb install tcpdump
opkg -dest usb install aircrack-ng
opkg -dest usb install kismet-client
opkg -dest usb install kismet-server
opkg -dest usb install perl
opkg -dest usb install openvpn
opkg -dest usb install dsniff
opkg -dest usb install nbtscan
opkg -dest usb install snort
opkg -dest usb install karma
opkg -dest usb install samba2-client
opkg -dest usb install elinks
opkg -dest usb install yafc
cp -f ./network.2 /etc/config/network
cp -f ./wireless.2 /etc/config/wireless
cp -f ./dhcp.2 /etc/config/dhcp

