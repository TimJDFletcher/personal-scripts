#!/bin/sh
for disk in b c a e ; do
        sudo parted -s -- /dev/sd$disk mklabel msdos
        sudo parted -s -- /dev/sd$disk mkpart primary 2048s -0
        sudo parted -s -- /dev/sd$disk set 1 raid on
done

