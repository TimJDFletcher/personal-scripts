#!/bin/sh
PATH=$PATH:/sbin:/usr/sbin
uuid=$1 ; shift
pool=$1 ; shift
luksdevice=luks$pool
if [ $(id -u) -gt 0 ] ; then
        echo $0 needs to be run as root
        exit 1
fi

#password=$(dmidecode -s system-serial-number | sha1sum | awk '{print $1}')
keyfile=/sys/devices/virtual/dmi/id/product_uuid

start()
{
if ! cryptsetup status $luksdevice ; then
	cryptsetup luksOpen --key-file $keyfile /dev/disk/by-uuid/$uuid $luksdevice
fi

if ! zpool status $pool 2>/dev/null ; then
	rm -f /etc/zfs/zpool.cache
	modprobe zfs spl
	if ! zpool import -d /dev/mapper $pool ; then
		echo "Backup drive not found or import failed"
		exit 1
	else
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
	zpool scrub $pool
}

stop()
{
if ! zpool status $pool 2>/dev/null ; then
	echo $pool not imported
elif zpool export $pool ; then
	sync ; sleep 10
	cryptsetup luksClose $luksdevice
	sync ; sleep 10
	hdparm -y /dev/disk/by-uuid/$uuid
	modprobe -r zfs
	modprobe -r spl
	rm -f /etc/zfs/zpool.cache
else
	echo ZFS drive in use bailing out
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
*)
	echo Unknown option $1
	exit 1
;;
esac
