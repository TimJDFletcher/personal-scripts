#!/bin/sh
cache_device=/dev/oxygen/photos.cache
cached_device=photos.cached
mountpoint=/iscsi/photos
dev=$(udevadm info -q name -n $cache_device)
iscsiserial=ec3453650b01
iscsitarget=iqn.2003-01.org.linux-iscsi.carbon.x8664:sn.${iscsiserial}
iscsiportal=192.168.1.2:3260,1

start()
{
    sudo iscsiadm --mode node --targetname $iscsitarget --portal $iscsiportal --login
    sleep 10
    sudo /sbin/flashcache_load /dev/${dev}
    sudo fsck -D -f /dev/mapper/$cached_device
    sudo mount $mountpoint
    sudo sysctl -w $(sysctl -a | grep ${iscsiserial}.*fast_remove | awk '{print $1}')=1
}

stop()
{
    sudo umount $mountpoint
    sudo sysctl -w $(sysctl -a | grep ${iscsiserial}.*fast_remove | awk '{print $1}')=0
    sudo dmsetup remove $cached_device
    sync ; sleep 10
    sudo iscsiadm --mode node --targetname $iscsitarget --portal $iscsiportal --logout
}

quickstop()
{
    sudo sysctl -w $(sysctl -a | grep ${iscsiserial}.*fast_remove | awk '{print $1}')=1
    sudo umount $mountpoint
    sudo dmsetup remove $cached_device
    sync ; sleep 10
    sudo iscsiadm --mode node --targetname $iscsitarget --portal $iscsiportal --logout
}

case $1 in
    start)
	start
	;;
    stop)
	stop
	;;
    quickstop)
	quickstop
	;;
    restart)
	quickstop
	start
	;;
esac
