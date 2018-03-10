#!/bin/sh
arch=i386
disk=$1

sudo umount ${disk}*
sync

sudo qemu-system-$arch \
-m 2048 \
-name "Windows XP Installer" \
-net none \
-hda $disk \
-cdrom /archives/iso/Microsoft/Windows/Client/XP/Windows-XP-professional-SP3.iso \
-boot once=d \
-usb -usbdevice tablet \
-localtime \
-vga std
