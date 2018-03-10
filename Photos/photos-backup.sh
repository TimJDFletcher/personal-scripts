#!/bin/sh
# Quick script to sync photos, assumes ZFS is started
KEEP=20
rsync -avPH --delete --inplace --no-whole-file /iscsi/photos/ /oxygen.zfs/backups/photos/
sudo zfs-auto-snapshot.sh --syslog -p snap --label=cron --keep=$KEEP oxygen.zfs/backups/photos

