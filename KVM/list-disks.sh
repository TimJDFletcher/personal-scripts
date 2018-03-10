#!/bin/sh
mpathfile=multipath.list.$(date +%Y-%m-%d)
VM=$1

if [ ! -f $mpathfile ] ; then
	sudo multipath -ll > multipath.list.$(date +%Y-%m-%d)
fi

virsh dumpxml $VM | grep -Eo mpath[0-9]{1,2} | xargs -I % grep % $mpathfile > $VM.disks

if ! virsh list | grep -q $VM ; then
    echo Warning $VM not running this host
fi

if [ -f $VM.disks ] ; then
	cat $VM.disks | grep -o "(.*)"| sed -e 's/^(3//g' -e 's/)$//g'
else
    echo Disk list now found for $VM
fi

