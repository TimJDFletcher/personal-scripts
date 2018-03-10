#!/bin/bash
date=$(date +%s)
blockcopyFlagsDefault="--raw --wait --finish"
tryCount=3
dumpmem=false

while getopts "t:m:d:" opt; do
    case $opt in
	d)
	    dom=$OPTARG
	    ;;
	m)
	    dumpmem=$OPTARG
	    ;;
	t)
	    tryCount=$OPTARG
	    ;;
	\?)
	    echo "Invalid option: -$OPTARG" >&2
	    ;;
    esac
done

export backuppath=/backup/nfs/libvirt/$dom
export tryCount
echo Backup of $dom beginning to $backuppath
mkdir -p $backuppath

virsh dumpxml --security-info $dom > $backuppath/$dom.xml
virsh undefine $dom ; sleep 2

do_backup()
{
    while [ $failCount -lt $tryCount ] ; do
	if ! virsh blockcopy $dom $disk $backuppath/$disk.raw $blockcopyFlags ; then
	    export failCount=$((failCount+1))
	    echo Backup of $disk from $dom failed retrying
	    sync ; sleep 10s
	else
	    echo Backup of $disk from $dom completed to $backuppath/$disk.raw
	    break
	fi
    done

    if [ $failCount -gt $tryCount ] ; then
	echo Backup of $disk from $dom failed after $failCount retries
	logger -t "libvirt backup" Backup of $disk from $dom failed after $failCount retries
	retun 1
    elif [ $failCount -gt 0 ] ; then
	echo Backup of $disk from $dom succeded after $failCount retries
	logger -t "libvirt backup" Backup of $disk from $dom succeded after $failCount retries
	return 0
    else
	echo Backup of $disk from $dom succeded
	logger -t "libvirt backup" Backup of $disk from $dom succeded
	return 0
    fi
}

disks=$(virsh domblklist --details $dom | grep disk | awk '{print $3}')

for disk in $disks ; do
    failCount=0
    if [ -f $backuppath/$disk.raw ] ; then
	export blockcopyFlags="$blockcopyFlagsDefault --reuse-external"
	chown libvirt-qemu:kvm $backuppath/$disk.raw
	chmod 660 $backuppath/$disk.raw
	do_backup
    else
	export blockcopyFlags="$blockcopyFlagsDefault"
	do_backup
    fi
    sync ; sleep 10
done

for disk in $disks ; do
    virsh blockjob $dom $disk --abort
    sync ; sleep 10
done

# Dump system RAM
if [ $dumpmem = true ] ; then
    echo Dumping system RAM for $dom to $backuppath/$dom.mem
    virsh save $dom $backuppath/$dom.mem --running
    sync
    virsh restore $backuppath/$dom.mem
fi

# Restart the VM and define it
virsh define $backuppath/$dom.xml

echo Backup of $dom completed to $backuppath
logger -t "libvirt backup"  Backup of $dom completed to $backuppath
