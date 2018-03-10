#!/bin/sh
source='usb-Seagate_Portable_2GHWHLHA-0:0'
cmdline='root=UUID=a7364e49-4f17-4a96-bd74-b8eb2beb67ae ro'

mountpoint=/run/usbhdd
vmlinuz=$mountpoint/syslinux/usbhdd/vmlinuz
initrd=$mountpoint/syslinux/usbhdd/initrd.img

sudo umount /dev/disk/by-id/$source-part1
sudo mkdir $mountpoint
sudo mount -o ro /dev/disk/by-id/$source-part1 $mountpoint
sync
sudo kexec --command-line="$cmdline" --initrd=$initrd $vmlinuz

