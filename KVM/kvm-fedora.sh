#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
macaddress=de:ad:be:ef:7f:94
disk=/dev/disk/by-path/ip-192.168.1.2:3260-iscsi-iqn.2011-10.carbon:kvm.fedora-lun-0
arch=x86_64
sudo qemu-system-$arch \
-smp 1 -m 1024 \
-name Fedora \
-net nic,model=virtio,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-drive file=$disk,if=virtio,boot=on \
-usb -usbdevice tablet  \
-localtime \
-vga std  $*


