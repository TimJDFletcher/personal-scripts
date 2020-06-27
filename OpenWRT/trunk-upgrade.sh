#!/bin/sh
set -e -u
image=openwrt-ipq806x-generic-netgear_r7800-squashfs-sysupgrade.bin
arch=ipq806x/generic
tempdir=$(mktemp -d /tmp/sysupgrade.XXXXXX )
packages="coreutils-sha256sum ca-bundle ca-certificates libustream-openssl"

opkg update
opkg install ${packages}

cd $tempdir
wget https://downloads.openwrt.org/snapshots/targets/$arch/$image
wget https://downloads.openwrt.org/snapshots/targets/$arch/sha256sums

sha256sum --ignore-missing -c sha256sums

echo sha256 checksum confirmed, flashing in 10 seconds
sleep 10
sysupgrade -v $tempdir/$image

