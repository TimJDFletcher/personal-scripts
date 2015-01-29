#!/bin/sh
image=openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-sysupgrade.bin
arch=ar71xx
tempdir=$(mktemp -d /tmp/sysupgrade.XXXXXX )

cd $tempdir
wget http://downloads.openwrt.org/snapshots/trunk/$arch/$image
wget http://downloads.openwrt.org/snapshots/trunk/$arch/md5sums

md5sum_download=$(grep $image md5sums | awk '{print $1}')
md5sum_calc=$(md5sum $image | awk '{print $1}')

if [ $md5sum_download = $md5sum_calc ] ; then
	echo md5sum confirmed, flashing in 10 seconds
	sleep 10
	sysupgrade -v $tempdir/$image
else
	echo md5sum does not match, aborting
	echo check $tempdir
	exit 1
fi

