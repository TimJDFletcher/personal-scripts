#!/bin/bash

# Requirements:
# - macOS
# - qemu - `brew install qemu`
# - A raw 64-bit Raspberry Pi system image to boot (Usually a .img)

# Raspberry Pi 3
DTB=bcm2710-rpi-3-b-plus.dtb
MACHINE=raspi3b
CPU=cortex-a53
CORES=4
RAM=1G
CONSOLE=ttyAMA1,115200
ROOTFS=/dev/mmcblk0p2

# Raspberry Pi 4
# Currently has no PCIe bus so no usb or network...
#DTB=bcm2711-rpi-4-b.dtb
#MACHINE=raspi4b
#CPU=cortex-a72
#CORES=4
#RAM=2G
#ROOTFS=/dev/mmcblk1p2
#CONSOLE=ttyAMA1,115200

# Shared parms
KERNEL=kernel8.img
DISKSIZE=8G

set -e

if [[ -z "$1" ]]; then
    echo "Disk image expected as argument" 1>&2
    exit 1
else
    IMAGE=$1
fi

# Mount disk and find where /boot is mounted
BOOT_MOUNT=$(
    hdiutil attach -imagekey diskimage-class=CRawDiskImage "$1" | grep 'Windows_FAT_32' | sed 's/.*\t//'
)

# Copy required files to local folder
mkdir -p kernel dtb
cp "$BOOT_MOUNT/$DTB" dtb/
cp "$BOOT_MOUNT/$KERNEL" kernel/

# Unmount disk
hdiutil detach "$BOOT_MOUNT"

# Make sure the disk is on a power of two boundary for QEMU
qemu-img resize -f raw "$IMAGE" "$DISKSIZE"

qemu-system-aarch64 \
    -M $MACHINE \
    -cpu $CPU \
    -smp $CORES \
    -m $RAM \
    -append "rw earlyprintk loglevel=8 console=$CONSOLE dwc_otg.lpm_enable=0 root=$ROOTFS rootdelay=1" \
    -dtb dtb/$DTB \
    -drive "if=sd,format=raw,file=$IMAGE" \
    -kernel kernel/$KERNEL \
    -serial mon:stdio \
    -usb \
	-device usb-mouse \
	-device usb-kbd \
	-device usb-net,netdev=net0 \
	-netdev user,id=net0
