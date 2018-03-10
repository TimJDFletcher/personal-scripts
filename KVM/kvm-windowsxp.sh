#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
macaddress=de:ad:be:ef:48:e8
arch=i386
sudo qemu-system-$arch \
-smp 2 -m 1024 \
-name WindowsXP \
-net nic,model=virtio,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-drive file=/dev/oxygen/WindowsXP,if=virtio,boot=on,cache=none \
-usb -usbdevice tablet  \
-localtime \
-vga std  $*


