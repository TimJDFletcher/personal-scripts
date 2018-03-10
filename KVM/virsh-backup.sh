#!/bin/sh
dom=$1
disks=$(virsh domblklist --details $dom | grep disk | awk '{print $3}')
date=$(date +%s)
backuppath=/tmp/$dom/$date

mkdir -p $backuppath
virsh dumpxml --security-info $dom > $backuppath/$dom.xml
virsh undefine $dom
for disk in $disks ; do
	virsh blockcopy $dom $disk $backuppath/$disk.raw --wait --finish --verbose
done
sleep 10 ; sync
for disk in $disks ; do
	virsh blockjob $dom $disk --abort
done

# virsh save $dom $backuppath/$dom.mem --running
# sleep 10 ; sync
# virsh restore $dom $backuppath/$dom.mem

virsh define $backuppath/$dom.xml


