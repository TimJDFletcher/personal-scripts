#!/bin/sh
# These are the VMs that we are syncing before backup
# vm_targets="Server-Tim Server-BenJ MySQL"
vm_targets="Server-Tim MySQL"
# Get the date in UNIX time
# date=$(date +%Y%m%d%H%M%S)
date=$(date +%s)
# These are the storage targets
storage_targets="/dev/SSD/images /dev/raid5/VM.images"
# Where are we backing up to, needs to be ZFS
backup_target="archives/backups"
# Where do we mount
mountpoint=/run/backup

# Login to VMs and kick off local backup / disk flush. We assume that the local admins can
# setup a script to do this. The backup script is called /usr/local/bin/backup (but can be
# changed by changing the forced command in the ssh config

# This is the /root/.ssh/authorized_keys line, remember to restorecon on selinux
# command="/usr/local/bin/backup",from="192.168.10.199",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8aRfnv5QFudmCDX+d4viu9KF9QYu37C3Dmia106MfPgRlS8B7SqTwobanvwc0jgzyVEpa5Xnkxn/83lbx1jSAGAwmsGTKg/ZH08zXe3RuHvUoRa7C7yP/krYg55gm9ujdUOvW6BbolEkR4bF5eU9F83q6TlczdeZaFUVc03Bm2P4hJ5DAtAzCqcPZX1jLHUNecGxg3d4ldmor3kcwMNFRG89Wr1ioGgSPm8EDqWTe/5IQAmo6D5kkZ60+dgIPkkTig5/gbkP/UBDo7gIg4WLgL4aIWkWPJeM88HAXc4c2a0xWWLzHCag+wBCnZUHlD9B0WlVGGMq3AUnqpCICEkQP backups@benj-hypervisor

# We are just issuing disk flushes with sysrq+s, Suspending the VM and then LVM snapping the storage
for VM in $vm_targets ; do
	virsh send-key $VM KEY_LEFTALT KEY_SYSRQ KEY_S
	sleep 1 ; sync
	virsh suspend $VM
done

# Kick off lvm snapshot
for storage in $storage_targets ; do
	shortname=$(basename $storage)
	/sbin/lvm lvcreate --quiet -L 10G --chunksize 512k -s -n ${shortname}.${date} $storage
done

# Release all VMs
for VM in $vm_targets ; do
	virsh resume $VM
done

# Apply zfs snapshot, zfs snapshot path/ @date
/sbin/zfs snapshot $backup_target@daily.$date

# Roll over each LVM storage group rsync it and then release it.
for storage in $storage_targets ; do
	shortname=$(basename $storage)
	mountname=$(echo $storage | sed -e s,^/dev/,,g -e s,/,.,g )
	# Mount up the lvm snaps, we could loop this in with the snapping but we want to resume the VMs ASAP
	mkdir -p $mountpoint/$date/$mountname
	/sbin/fsck -p ${storage}.${date}
	if ! mount -o ro ${storage}.${date} $mountpoint/$date/$mountname ; then
		echo failed to mount ${storage}.${date}
	else
		# rsync images onto zfs disks with no-whole-file and inplace
		/usr/bin/rsync -axH --no-whole-file --inplace --delete $mountpoint/$date/$mountname/ /$backup_target/$mountname/
	fi
	sleep 10 ; sync
	# unmount the snapshots and remove them
	umount ${storage}.${date}
	sleep 10 ; sync
	/sbin/lvm lvremove --quiet --force ${storage}.${date}
	rmdir $mountpoint/$date/$mountname
done

rmdir -p --ignore-fail-on-non-empty $mountpoint/$date

# Dump / to the zfs
/usr/bin/rsync -axH --no-whole-file --inplace --delete / /$backup_target/root/

