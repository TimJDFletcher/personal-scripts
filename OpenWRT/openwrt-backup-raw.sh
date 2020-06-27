#!/bin/bash
set -e -u
host=${1}
recipient=tim@night-shade.org.uk
dir=$HOME/OpenWRT

ssh $host tar -c -C /overlay/upper ./ |
  pigz -c |
  gpg -e -r $recipient >"$dir/$host-backup-raw-$(date +%Y%m%d-%H%M)".tar.gz.gpg
