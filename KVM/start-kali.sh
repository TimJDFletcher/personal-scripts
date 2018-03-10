#!/bin/sh
kaliLUKSuuid=eb07429a-b31f-4882-ac46-a19fb2bfab87
plaindev=kali.plain
vg=bismuth
mounts="/var/lib/autopsy /kali"

start()
{
	sudo cryptsetup --allow-discards luksOpen UUID=$kaliLUKSuuid $plaindev
	sudo vgchange -a y $vg
	for mount in $mounts ; do 
		sudo mount $mount
	done
}

stop()
{
	for mount in $mounts ; do 
		sudo umount $mount
	done
	sudo vgchange -a n $vg
	sudo cryptsetup luksClose $plaindev
}

case $1 in
stop)
	stop
;;
start)
	start
;;
restart)
	stop
	sleep 10
	start
;;
esac
