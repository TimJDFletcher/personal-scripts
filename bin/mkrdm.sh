#!/bin/sh
export count=1 
VM=$1
if [ -f $VM.disks ] ; then
    serials=$(cat $VM.disks | grep -o "(.*)"| sed -e 's/^(3//g' -e 's/)$//g')
fi

for serial in $serials ; do 
    echo vmkfstools -r /vmfs/devices/disks/naa.$serial disk-$count.vmdk
    count=$((count+1))
done
