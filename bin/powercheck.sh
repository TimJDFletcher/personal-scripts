#!/bin/sh
devices="a b c d e"
for dev in $devices ; do
	sudo /sbin/hdparm -C /dev/sd$dev
done


