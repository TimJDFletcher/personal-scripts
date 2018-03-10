#!/bin/sh
date=$(date +%Y%m%d%H%M)
# Assuming is naughty!
imagedev=/dev/sda

if [ x$1 != x ] ; then
	destdir=/backups/images/$1-$date
fi

mkdir -p $destdir
sudo dd if=$imagedev of=$destdir/ptable bs=512 count=1
pigz -9 $destdir/ptable
sudo ntfsclone ${imagedev}1 -s -o - | pigz -c > $destdir/osimage.ntfs.gz
