#!/bin/sh
tempdir=$(mktemp -d /tmp/sysupgrade.XXXXXX )
image=openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-sysupgrade.bin
arch=ar71xx
url=http://downloads.openwrt.org/attitude_adjustment/12.09-rc1

cd $tempdir
wget $url/$arch/generic/$image
wget $url/$arch/generic/md5sums

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

