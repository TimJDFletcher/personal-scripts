#!/usr/bin/env bash
set -u -e

host=$1
gpg_recipient=tim@night-shade.org.uk
dir=$HOME/OpenWRT

mkdir -p $dir
ssh $host sysupgrade -b - | \
    gpg -e -r $gpg_recipient > $dir/$host-backup-$(date +%Y%m%d-%H%M).tar.gz.gpg
