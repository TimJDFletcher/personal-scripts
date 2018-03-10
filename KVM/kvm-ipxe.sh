#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
diskid=
macaddress=DE:AD:BE:EF:56:EF
arch=x86_64
disk=/dev/disk/by-id/${diskid}-0:0
kernel=/usr/src/git/ipxe/src/bin/ipxe.lkrn

# sudo qemu-system-$arch \
qemu-system-$arch \
-m 512 \
-name ipxe \
-kernel $kernel \
-net nic,model=e1000,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-usb -usbdevice tablet \
-localtime \
-vga std $*
