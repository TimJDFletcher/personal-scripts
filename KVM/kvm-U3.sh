#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
diskid=usb-_Patriot_Memory_070726A3A57F4937
macaddress=DE:AD:BE:EF:87:6A
arch=x86_64
disk=/dev/disk/by-id/${diskid}-0:0

sudo umount /dev/disk/by-id/${diskid}* 
sync

sudo qemu-system-$arch \
-m 1024 \
-name U3 \
-net nic,model=virtio,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-drive file=$disk,if=virtio \
-usb -usbdevice tablet \
-localtime \
-vga std $*

