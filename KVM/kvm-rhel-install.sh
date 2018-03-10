#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
macaddress=$(printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)))
arch=x86_64
disk=$1

sudo umount ${disk}* 
sync

sudo qemu-system-$arch \
-m 2048 \
-name RHEL\ Installer \
-net nic,model=virtio,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-cdrom /archives/iso/Linux/RHEL/6.3/rhel-server-6.3-x86_64-dvd.iso \
-boot once=d \
-drive file=$disk,if=virtio \
-usb -usbdevice tablet \
-localtime \
-vga std

