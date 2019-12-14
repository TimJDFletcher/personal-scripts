#!/bin/sh
host=$1
recipient=tim@night-shade.org.uk
dir=$HOME/OpenWRT
if [ -z $host ] ; then
        echo "Usage $0 <hostname>"
        exit 1
fi
mkdir -p $dir
ssh $host sysupgrade -b - | \
    gpg -e -r $recipient > $dir/$host-backup-$(date +%Y%m%d-%H%M).tar.gz.gpg
