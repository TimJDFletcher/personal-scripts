#!/bin/sh
DEVID=$1
BUSID=$(lspci -n | grep $1 | awk '{print $1}')
modprobe pci-stub ids=$DEVID
echo "$DEVID" | sed -e 's/:/ /g' > /sys/bus/pci/drivers/pci-stub/new_id
echo "0000:$BUSID" > /sys/bus/pci/devices/0000:$BUSID/driver/unbind
echo "0000:$BUSID" > /sys/bus/pci/drivers/pci-stub/bind

