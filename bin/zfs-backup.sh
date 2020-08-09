#!/bin/bash
set -e -u -o pipefail
HOST=${ZFS_BACKUP_HOST:-boron.vpn.night-shade.org.uk}
POOL=${ZFS_BACKUP_POOL:-boron}
UUID=$(ioreg -ad2 -c IOPlatformExpertDevice | xmllint --xpath '//key[.="IOPlatformUUID"]/following-sibling::*[1]/text()' -)
TARGET=backups/uuid/$UUID
SOURCE=/System/Volumes/Data
USER=root
SPEEDLIMIT=${ZFS_BACKUP_SPEEDLIMIT:-500K}

check_target_exists() {
    ssh -F $HOME/.ssh/config \
        $USER@$HOST \
            "[ -e /$POOL/$TARGET/ ]"
}

do_backup() {
caffeinate sudo -E rsync \
    --rsh "ssh -F $HOME/.ssh/config -o UserKnownHostsFile=$HOME/.ssh/known_hosts" \
    --compress \
    --archive \
    --bwlimit ${SPEEDLIMIT} \
    --hard-links \
    --partial \
    --verbose \
    --progress \
    --one-file-system \
    --numeric-ids \
    --ignore-errors \
    --inplace \
    --delete \
    --delete-after \
    $SOURCE/ $USER@$HOST:/$POOL/$TARGET/
}

check_target_exists
do_backup
