#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
macaddress=DE:AD:BE:EF:C1:85
overlay=/home/tim/openwrt-x86/openwrt-x86-overlay.img
#rootfs=/home/tim/openwrt-x86/openwrt-x86-generic-rootfs-squashfs.img
rootfs=/home/tim/openwrt-x86/openwrt-x86-generic-rootfs-ext4.img
#kernel=/home/tim/openwrt-x86/openwrt-x86-generic-vmlinuz
kernel=/home/tim/openwrt-x86/vmlinuz+initrd
arch=i386

qemu-system-$arch \
-m 64 \
-name OpenWRT \
-net none \
-drive file=$rootfs,if=ide \
-drive file=$overlay,if=ide \
-usb -usbdevice tablet  \
-kernel $kernel \
-append "console=ttyS0,115200" \
-localtime \
-serial stdio \
-vnc :1 $*

# -net nic,model=e1000,macaddr=$macaddress \
# -net tap,ifname=tap0,script=no,downscript=no \
# -append "root=/dev/sda" \

