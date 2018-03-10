#!/bin/sh
device=$1
mountpoint=/mnt
target=/backups/files
date=$(date +%s)

if [ x$device = x ] ; then
	echo "$0 <device to backup>"
	exit 1
fi

sudo mount $device $mountpoint -o ro

sleep 10

hivepath=$(hivefinder.sh $target system)

computername=$(cat ~/bin/Computername.chntpw | chntpw $hivepath 2>/dev/null | grep -C 1 REG_SZ  | tail -n 1)

cd $mountpoint

sudo /bin/tar --create --gzip --verbose --file=$target/$computername-$date.tar.gz ./

sync
sleep 1m
sync

sudo umount $device
