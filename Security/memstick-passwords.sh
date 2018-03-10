#!/bin/sh
label=keystick

if [ -L /dev/disk/by-label/$label ] ; then
	udisks --mount /dev/disk/by-label/$label
	keepass2 /media/$label/Keepass2/Passwords.kdbx
	sleep 10s
	udisks --unmount /dev/disk/by-label/$label
else
	zenity --error --text "$label not found"
	exit 1
fi
