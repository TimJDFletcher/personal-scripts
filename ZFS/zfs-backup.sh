#!/bin/sh
. /etc/backup/zfs-backup.conf

if [ $(id -u) -gt 0 ] ; then
	echo $0 needs to be run as root
	exit 1
fi

if ! zfs-control.sh start ; then
	echo Failed to start ZFS pool, bailing out
	logger Failed to start ZFS pool, backup aborted
	exit 1
fi


vglock()
{
lockfile=/run/lock/zfsbackup.$vg
if [ -f $lockfile ] ; then
	echo $lockfile found, bailing out
	logger ZFS backup aborted, lock file found
	break
else
	logger ZFS backup started
	touch $lockfile
fi
}

vgunlock()
{
lockfile=/run/lock/zfsbackup.$vg
if [ -f $lockfile ] ; then
	rm -f $lockfile
fi
}

vgbackup()
{
backupdir=$backupfs/$vg
# Find and backup all volumes in the volume group
echo "Backing up volume group $vg"
mkdir -p $snapshot_mountpoint/$date
for volume in $(lvm lvs --noheadings -o lv_name $vg) ; do
	if grep -q "^/dev/mapper/${vg}-${volume} " /proc/mounts ; then
		echo "$volume"
		# Take an LVM snapshot 10% of the size of the origin volume
		lvm lvcreate --quiet --extents 10%ORIGIN --chunksize 512k --snapshot --name ${volume}.${date} /dev/${vg}/${volume}
		blockdev --setro /dev/${vg}/${volume}.${date}
		mkdir -p $snapshot_mountpoint/$date/$volume
		# Actually backup files
		if mount -o ro /dev/${vg}/${volume}.${date} $snapshot_mountpoint/$date/$volume ; then
			mkdir -p /$backupdir/$volume/
			$rsync_cmd $rsyncargs $snapshot_mountpoint/$date/$volume/ /$backupdir/$volume/
			umount $snapshot_mountpoint/$date/$volume
		else
			echo "$volume snapshot failed to mount skipping backup"
		fi
		sync ; sleep 10
		if ! lvm lvremove --quiet --force ${vg}/${volume}.${date} ; then
			echo lvremove failed, sleeping 30 seconds and using dmsetup
			sync ; sleep 30
			dmsetup remove ${vg}-${volume}-real
			dmsetup remove ${vg}-${volume}.${date}
			lvm lvremove --quiet --force ${vg}/${volume}.${date}
		fi
		rmdir $snapshot_mountpoint/$date/$volume
	else
		echo "$volume not mounted skipping backup"
	fi
done
rmdir $snapshot_mountpoint/$date
echo done
}

mountpointbackup()
{
echo -n "$(basename $mountpoint), "
if grep -q " $mountpoint " /proc/mounts ; then
	if [ "x/" = "x$mountpoint" ] ; then
		safename=root
	else
		safename=$(echo $mountpoint | sed -e s,^/,,g -e s,/,.,g )
	fi

	mkdir -p $snapshot_mountpoint/$date/$safename
	if mount -o ro,bind $mountpoint $snapshot_mountpoint/$date/$safename ; then
		$rsync_cmd $rsyncargs $snapshot_mountpoint/$date/$safename/ /$backupdir/$safename/
		umount $snapshot_mountpoint/$date/$safename
	fi
	rmdir $snapshot_mountpoint/$date/$safename
fi
rmdir $snapshot_mountpoint/$date
}

# Could be expanded to read storage locations out of libvirt
libvirtbackup()
{
runningDomains=$(virsh list --all --state-running | egrep '^ [0-9]|^ -' | awk '{print $2}')
mountpoint=$(df /var/lib/libvirt/images | tail -n 1 | awk '{print $6}')

if [ "x/" = "x$mountpoint" ] ; then
	safename=root
else
	safename=$(echo $mountpoint | sed -e s,^/,,g -e s,/,.,g )
fi

for domain in $runningDomains ; do
	echo Hot backing up $domain
	virsh domblklist --details $domain |  egrep '^file[[:space:]]*disk' | awk '{print $3,$4}' | grep /var/lib/libvirt/images | while read disk file ; do
		if [ -f $file ] ; then
			virsh snapshot-create-as --domain $domain backup.$date --diskspec $disk,file=$file.$date --disk-only --atomic
			$rsync_cmd $rsyncargs $file /$backupdir/$(echo $file | sed -e "s,$mountpoint,$safename,g")
			if virsh blockcommit $domain $file.$date --shallow --active --pivot --verbose ; then
				rm $file.$date
				virsh snapshot-delete $domain backup.$date --metadata
			else
				echo Snapshot removal of backup.$date from $domain failed
			fi
		else
			echo File $file not found, skipping
		fi
	done
done
}

echo "Backing up volume groups"
for vg in $vgs ; do
	vglock
	vgbackup
	vgunlock
done

echo -n "Backing up other filesystems: "
backupdir=$backupfs
for mountpoint in $extramountpoints ; do
	mountpointbackup
done
echo done

if [ x$libvirtbackup = xtrue ] ; then
	echo "Backing up libvirt disk images"
	backupdir=$backupfs
	libvirtbackup
fi


case x$1 in
xcron)
	zfs-auto-snapshot.sh --syslog -p snap --label=cron   --keep=$retention_cron $backupfs
;;
x)
	zfs-auto-snapshot.sh --syslog -p snap --label=manual --keep=$retention_manual $backupfs
;;
*)
	zfs-auto-snapshot.sh --syslog -p snap --label=$1     --keep=$retention_manual $backupfs
;;
esac

zpool list $pool

logger ZFS backup completed
zfs-control.sh stop
