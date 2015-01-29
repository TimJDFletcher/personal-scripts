#!/bin/sh
PATH=$PATH:/sbin:/usr/sbin:/usr/local/bin
uuid=b219656b-2a4c-4dd8-b3eb-815e2b313c0c
backuppool=backups.iron
sourcepool=iron
date=$(date +%s)
rsync_cmd=rsync
rsyncargs="-axH --numeric-ids --no-whole-file --inplace --delete"
extramountpoints="/boot /"
exclude="backups/work/laptop"
rsynctarget=/$sourcepool/backups/system

if [ $(id -u) -gt 0 ] ; then
        echo $0 needs to be run as root
        exit 1
fi

if ! luks-zfs-control.sh $uuid $backuppool start ; then
        echo Failed to start ZFS pool $backuppool, bailing out
        logger Failed to start ZFS pool $backuppool, backup aborted
        exit 1
fi

# Backup any extra mountpoints, eg /boot first before we send the pool over
for mountpoint in $extramountpoints ; do
        echo -n "$(basename $mountpoint), "
        if grep -q $mountpoint /proc/mounts ; then
                safename=$(echo $mountpoint | sed -e 's,^/$,root,g' -e s,^/,,g -e s,/,.,g )
           	$rsync_cmd $rsyncargs $mountpoint $rsynctarget/$safename/
        fi
done
echo done

zfs snapshot -r $sourcepool@backup-$date
oldsnap=$(zfs list -t snap | grep "^${sourcepool}@backup-" | head -n 1 | awk '{print $1}' | cut -d - -f 2)
newsnap=$(zfs list -t snap | grep "^${sourcepool}@backup-" | tail -n 1 | awk '{print $1}' | cut -d - -f 2)


for fs in $(zfs list  | grep ^${sourcepool}/| awk '{print $1}' | cut -d "/" -f 2-) ; do
	if [ $fs = $exclude ] ; then continue ; fi
	echo   Doing backups from  ${sourcepool}/$fs@backup-$oldsnap to ${backuppool}/$fs@backup-$newsnap
	logger Doing backups from  ${sourcepool}/$fs@backup-$oldsnap to ${backuppool}/$fs@backup-$newsnap
	zfs send -i ${sourcepool}/$fs@backup-$oldsnap ${sourcepool}/$fs@backup-$newsnap | zfs receive $backuppool/$fs
done

luks-zfs-control.sh $uuid $backuppool stop
echo Clearing old snapshots in 10 seconds ; sleep 10
zfs list -t snap | awk '{print $1}' | grep "^${sourcepool}" | grep '@backup-' | grep -v $newsnap | xargs --no-run-if-empty -n 1 zfs destroy
