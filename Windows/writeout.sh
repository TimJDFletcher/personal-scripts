#!/bin/sh
imagesdir=/backups/images

writeout()
{
pigz -c $image/ptable.gz | sudo dd of=$dev
sync
sudo partprobe
pigz -c $image/bootpartion.ntfs.gz | sudo ntfsclone -O $dev-part1 -r -
pigz -c $image/osimage.ntfs.gz     | sudo ntfsclone -O $dev-part2 -r -
}

case $1 in
standalone)
	export name=Win7Standalone
;;
windows7.kvm|w7kvm|w7vm)
	export name=Windows7-KVM
;;
*)
	echo Unknown image type, exiting
	exit 1
;;
esac

if [ x$image = x ] ; then
	export image=$(find $imagesdir -mindepth 1 -maxdepth 1 -type d -name $name-201\* | sort -n | tail -n 1)
fi

if [ x$dev = x ] ; then
	export dev=$(find /dev/disk/by-id/ -type l -iname scsi-sata* | grep -v part)
fi


echo -n "Imaging from $image to $dev type yes if you are sure: "
read answer

if [ xyes != x"$answer" ] ; then
	echo Aborting
	exit
else
	sudo blockdev --setrw $dev
	writeout
fi
