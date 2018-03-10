#!/bin/sh
# from printf 'DE:AD:BE:EF:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256))
# diskid=usb-SanDisk_U3_Cruzer_Micro_08776011C691C3A5
diskid=scsi-SATA_TOSHIBA_MK3252G_X8LBC388T
macaddress=DE:AD:BE:EF:43:8C
arch=x86_64
disk=/dev/disk/by-id/${diskid}

sudo umount /dev/disk/by-id/${diskid}*
sync

sudo qemu-system-$arch \
-m 1024 \
-name USBHDD \
-net nic,model=virtio,macaddr=$macaddress \
-net tap,ifname=tap0,script=no,downscript=no \
-drive file=$disk,if=virtio,boot=on \
-usb -usbdevice tablet \
-localtime \
-vga vmware $*
