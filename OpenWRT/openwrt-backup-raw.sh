#!/bin/sh
host=wt3020
recipient=tim@night-shade.org.uk
dir=$HOME/OpenWRT
ssh $host tar -c -C /overlay/upper ./ | pigz -c | gpg2 -e -r $recipient > $dir/wt3020-backup-raw-$(date +%Y%m%d-%H%M).tar.gz.gpg
