#!/bin/sh
arch=x86_64

sudo blockdev --setrw /dev/sda

sudo qemu-system-$arch \
-smp 2 -m 2048 \
-name sda \
-net none \
-drive file=/dev/sda,if=virtio,boot=on,cache=none \
-usb -usbdevice tablet  \
-localtime \
-vga std $*
