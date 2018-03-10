#!/bin/sh
masterdevice='/dev/disk/by-path/pci-0000:00:1a.0-usb-0:1.3:1.0-scsi-0:0:0:'
bmapfile=/images/FitPC-master-image-20150316.sparse.gz
bmaptool=$(which bmaptool)

ssdwipe()
{
password=Password1
hdparm --user-master u --security-set-pass $password $1
hdparm --user-master u --security-erase $password $1
}

writeimage()
{
$bmaptool copy $bmapfile $1
}


if [ x$1 != x ] ; then
	slot=$1
else
	echo $0 slotid
	exit 1
fi

export device=${masterdevice}${slot}
model=$(hdparm -I $device | grep "Model Number:" | awk '{$1=$2=""; print $0}')
serial=$(hdparm -I $device | grep "Serial Number:" | awk '{$1=$2=""; print $0}')
echo "You are about to overwrite device $model with serial number $serial"
echo Secure erasing $device
ssdwipe $device
sleep 10
echo Writting $imagefile to $device
writeimage $device
sync
