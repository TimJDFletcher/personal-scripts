#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
macaddress=DE:AD:BE:EF:D4:BD
disk=/dev/disk/by-path/ip-192.168.1.2:3260-iscsi-iqn.2011-10.carbon:kvm.windows7-lun-0
arch=x86_64
sudo qemu-system-$arch \
-smp 2 -m 1024 \
-cpu core2duo \
-name Windows7 \
-net nic,model=virtio,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-drive file=$disk,if=virtio \
-usb -usbdevice tablet  \
-localtime \
-vga std  $*


