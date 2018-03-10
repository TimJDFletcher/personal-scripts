#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
macaddress=DE:AD:BE:EF:8C:AA
arch=x86_64
disk=$1

sudo umount ${disk}* 
sync

sudo qemu-system-$arch \
-m 2048 \
-name Ubuntu\ Installer \
-net nic,model=virtio,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-cdrom /archives/iso/Linux/Ubuntu/12.10/ubuntu-12.10-server-amd64.iso \
-boot once=d \
-drive file=$disk,if=virtio \
-usb -usbdevice tablet \
-localtime \
-vga std

