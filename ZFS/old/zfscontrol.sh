#!/bin/sh
PATH=$PATH:/sbin:/usr/sbin
uuid=65c49ed1-3f73-406a-9a7a-12bcf37a1d31
luksdevice=zfsbackups
pool=backups
keyfile=/etc/pki/backups.key
modules="zfs zavl zunicode zcommon znvpair spl"
if [ $(id -u) -gt 0 ] ; then
        echo $0 needs to be run as root
        exit 1
fi
mountcheck()
{
if ! grep "^$pool /$pool" /proc/mounts ; then
	if ! zfs mount $pool ; then
		echo "Backup drive not found or import failed"
		exit 1
	fi
fi
}

start()
{
if ! cryptsetup status $luksdevice ; then
	cryptsetup luksOpen --key-file $keyfile /dev/disk/by-uuid/$uuid $luksdevice
fi

if ! zpool status $pool 2>/dev/null ; then
	rm -f /etc/zfs/zpool.cache
	modprobe zfs
	if ! zpool import -d /dev/mapper $pool ; then
		echo "Backup drive not found or import failed"
		exit 1
	else
		mountcheck
		diskperf
	fi
fi

}

diskperf()
{
# Setup disk performance
devname=$(udevadm info -q name -n /dev/disk/by-uuid/$uuid)
smartctl -l scterc,70,70 /dev/disk/by-uuid/$uuid
hdparm -W 1 /dev/disk/by-uuid/$uuid
echo 8192 > /sys/block/$devname/queue/nr_requests
echo deadline > /sys/block/$devname/queue/scheduler
}

forcestart()
{
if ! cryptsetup status $luksdevice ; then
	echo $password | cryptsetup luksOpen /dev/disk/by-uuid/$uuid $luksdevice
fi
if ! zpool status $pool 2>/dev/null ; then
	rm -f /etc/zfs/zpool.cache
	if ! zpool import -f -d /dev/mapper $pool ; then
		echo "Backup drive not found or import failed"
		exit 1
	else
		diskperf
	fi
fi
}

scrub()
{
	start
	sleep 10
	zpool scrub $pool
}

stop()
{
if ! zpool status $pool 2>/dev/null ; then
	echo $pool not imported
	hdparm /dev/disk/by-uuid/$uuid
elif zpool export $pool ; then
	sync ; sleep 10
	cryptsetup luksClose $luksdevice
	sync ; sleep 10
	hdparm /dev/disk/by-uuid/$uuid
	rm -f /etc/zfs/zpool.cache
else
	echo ZFS drive in use bailing out
fi
}

unload()
{
if zpool status $pool 2>/dev/null ; then
	echo $pool imported
else
	for module in $modules ; do 
		modprobe -r $module
	done
	echo 3 > /proc/sys/vm/drop_caches 
fi
}

case $1 in
start)
	start
;;
forcestart)
	forcestart
;;
stop)
	stop
;;
restart)
	stop
	sleep 5
	start
;;
force)
	stop
	sleep 5
	forcestart
;;
scrub)
	scrub
;;
rmmod)
	stop
	sleep 5
	unload
;;
*)
	echo Unknown option $1
	echo "Options are: start, stop, forcestart, restart and scrub"
	exit 1
;;
esac
