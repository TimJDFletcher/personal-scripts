#!/bin/sh
label="KEYSTICK"
keys="personal-dss brighter-dss wems-dsa"

secureadd()
{
	temp_key=$(mktemp $HOME/$(basename $1).XXXXXX)
	cp $1 $temp_key
	chmod 600 $temp_key
	ssh-add $temp_key
	shred --remove $temp_key
}

if [ ! -L /dev/disk/by-label/$label ] ; then
	echo "Key stick not found"
	exit 1
fi

udisks --mount /dev/disk/by-label/$label

for key in $keys ; do
	secureadd /media/$label/ssh-keys/private/$key
done
keychain --inherit any

udisks --unmount /dev/disk/by-label/$label
