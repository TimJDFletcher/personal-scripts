#!/bin/sh
packages="kmod-fs-ext4 kmod-usb-storage block-mount"
dev=sda1
swapdev=sda2
fstype=ext4
options=rw,sync,noatime

enable()
{
echo "Stopping automounting"
/etc/init.d/fstab stop

opkg update
opkg install $packages

sleep 10

while [ ! -b /dev/$dev ] ; do
        echo "/dev/$dev not found please insert the USB storage device"
        read junk
done

mkdir -p /mnt/$dev
mount /dev/$dev /mnt/$dev -t $fstype -o $options

tar -C /overlay -cvf - . | tar -C /mnt/$dev -xf -

uci add fstab mount
uci set fstab.@mount[-1].device=/dev/sda1
uci set fstab.@mount[-1].options=$options
uci set fstab.@mount[-1].enabled_fsck=0
uci set fstab.@mount[-1].enabled=1
uci set fstab.@mount[-1].target=/overlay
uci set fstab.@mount[-1].fstype=$fstype

uci add fstab swap
uci set fstab.@swap[-1].device=/dev/sda1
uci set fstab.@swap[-1].enabled=1

uci commit fstab

/etc/init.d/fstab enable

echo "Overlay enabled, you need to reboot to activate it"
}

enable

