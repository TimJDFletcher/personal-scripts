#!/bin/sh
set -e -u
image=openwrt-ipq806x-generic-netgear_r7800-squashfs-sysupgrade.bin
arch=ipq806x/generic
tempdir=$(mktemp -d /tmp/sysupgrade.XXXXXX)
packages="coreutils-sha256sum"

cd $tempdir
wget https://downloads.openwrt.org/snapshots/targets/$arch/$image
wget https://downloads.openwrt.org/snapshots/targets/$arch/sha256sums

opkg update
opkg install -d ram ${packages}

/tmp/usr/libexec/sha256sum-coreutils --ignore-missing -c sha256sums

echo sha256 checksum confirmed, flashing in 10 seconds
sleep 12

sysupgrade -v $tempdir/$image
