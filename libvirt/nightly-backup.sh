#!/bin/bash

# Wait up to an hour before starting backups
sleep $[ ( $RANDOM % 3600 )  + 1 ]s

for domain in $(virsh list | grep -v WEMS-| grep -E "^ [0-9]" | awk '{print $2}') ; do 
    /etc/backups/libvirt-backup.sh -d $domain
done

# Basic backup of the host system as well
rsync --delete -axHS / /backup/nfs/host/$HOSTNAME/

# Backup the libvirt XML files too
rsync --delete -axHS /etc/libvirt/qemu/ /backup/nfs/gluster/qemu/

