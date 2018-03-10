#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
diskid=usb-Kingston_DataTraveler_2.0_F46D04B071B3ED2109270139
macaddress=DE:AD:BE:EF:E7:D4
arch=x86_64
disk=/dev/disk/by-id/${diskid}-0:0

sudo umount /dev/disk/by-id/${diskid}* 
sync

sudo qemu-system-$arch \
-m 1024 \
-name openssl \
-net none \
-drive file=$disk,if=virtio \
-usb -usbdevice tablet \
-localtime \
-vga std $*


