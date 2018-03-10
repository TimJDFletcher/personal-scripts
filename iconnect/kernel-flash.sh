#!/bin/sh
md5sum=f9a495fe53fe6056eb81ae148bfac661
check=$(cat /proc/mtd  | md5sum | awk '{print $1}' )
kernel_mtd=3
initrd_mtd=4
kernel=uImage
initrd=uInitrd

if [ $md5sum != $check ] ; then 
	exit 1
fi

if [ -f /boot/$kernel ] ; then
	flash_erase /dev/mtd$kernel_mtd 0 0
	nandwrite -p /dev/mtd$kernel_mtd /boot/$kernel
fi

if [ -f /boot/$initrd ] ; then
	flash_erase /dev/mtd$initrd_mtd 0 0
	nandwrite -p /dev/mtd$initrd_mtd /boot/$initrd
fi

