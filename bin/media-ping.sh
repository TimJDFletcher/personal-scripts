#!/bin/sh
if [ x$1 = x ] ; then 
	echo "$0 <device to find>"
	exit 1
fi

case $1 in 
U3|U3.FAT)
	uuid=B513-148A
;;
Toshiba.Ubuntu|usbhdd)
	uuid=a7364e49-4f17-4a96-bd74-b8eb2beb67ae
;;
*)
	echo Unknown device
	exit 1
;;
esac

device=$(blkid -U $uuid)

if [ x$device != x ] ; then
	found=true
	mountpoint=$(cat /proc/mounts | grep $device | awk '{print $2}')
fi

if [ x$mountpoint != x ]; then
	echo "Removable drive plugged in and mounted at $mountpoint"
	exit 0
elif [ x$found = xtrue ]; then
	echo "Removable drive plugged in but not mounted"
	exit 1
else
	echo "Removable drive not plugged in"
	exit 1
fi

