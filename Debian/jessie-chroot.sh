#!/bin/bash
mirror=http://ftp.uk.debian.org/debian
targetdir=/working/jessie-chroot
distro=jessie

rm -rf $targetdir
mkdir $targetdir

debootstrap --arch=armhf --foreign --variant=minbase --include=wget $distro $targetdir $mirror

