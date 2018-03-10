#!/bin/sh
target=/var/run/luks
mkdir -p $target
for partition in $(egrep dm\|sd < /proc/partitions | awk '{print $4}' ) ; do
	if cryptsetup isLuks /dev/$partition ; then
		UUID=$(cryptsetup luksUUID /dev/$partition)
		if [ ! -f $target/${UUID}.header ] ; then
			echo Backing up LUKS header from /dev/$partition to $target/${UUID}.header
			cryptsetup luksHeaderBackup /dev/$partition --header-backup-file $target/${UUID}.header
		else
			echo File $target/${UUID}.header already exists
		fi
	fi
done
