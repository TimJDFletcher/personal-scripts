#!/bin/sh
cd /boot
mkimage -A arm -O linux -T kernel  -C none -n uImage  -a 0x00008000 -e 0x00008000 -d vmlinuz uImage
mkimage -A arm -O linux -T ramdisk -C none -n uInitrd                             -d initrd.img uInitrd

