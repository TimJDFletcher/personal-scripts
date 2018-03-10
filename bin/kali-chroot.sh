#!/bin/bash
mirror=http://archive.kali.org/kali
targetdir=/working/kali
distro=kali
architecture=armhf

mkdir -p $targetdir/kernel
mkdir -p $targetdir/rootfs
cd $targetdir/rootfs

debootstrap --foreign --arch=$architecture kali kali-$architecture http://archive.kali.org/kali
cp /usr/bin/qemu-arm-static kali-$architecture/usr/bin/
