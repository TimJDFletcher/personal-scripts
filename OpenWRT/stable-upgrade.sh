#!/bin/sh
arch=ar71xx
hardware=wndr3700v2
tempdir=$(mktemp -d /tmp/sysupgrade.XXXXXX )
version=15.05-rc3
name=chaos_calmer
md5sum_calc=$RANDOM
url=http://downloads.openwrt.org/$name/$version/$arch/generic
image=openwrt-${version}-${arch}-generic-${hardware}-squashfs-sysupgrade.bin

cd $tempdir
if wget $url/$image $url/md5sums ; then
	md5sum_download=$(grep $image md5sums | awk '{print $1}')
	md5sum_calc=$(md5sum $image | awk '{print $1}')
else
	echo Download failed bailing out
	exit 1
fi

if [ $md5sum_download = $md5sum_calc ] ; then
        echo md5sum confirmed, flashing in 10 seconds
        sleep 10
        sysupgrade -v $tempdir/$image
else
        echo md5sum does not match, aborting
        echo check $tempdir
        exit 1
fi

