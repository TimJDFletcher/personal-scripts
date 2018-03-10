#!/bin/sh
for mountpoint in $(cat /proc/mounts | grep discard| awk '{print $2}') ; do
	sudo fstrim -v $mountpoint
done
