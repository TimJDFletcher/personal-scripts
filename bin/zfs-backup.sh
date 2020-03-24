#!/bin/bash
set -e -u -o pipefail
HOST=${1:-boron-vpn}
POOL=boron
UUID=$(ioreg -ad2 -c IOPlatformExpertDevice | xmllint --xpath '//key[.="IOPlatformUUID"]/following-sibling::*[1]/text()' -)
TARGET=backups/uuid/$UUID
SOURCE=/System/Volumes/Data
USER=root
SPEEDLIMIT=${SPEEDLIMIT:-500K}

ssh -F $HOME/.ssh/config \
    $USER@$HOST \
    "[ -e /$POOL/$TARGET/ ]"

caffeinate sudo -E rsync \
    --rsh "ssh -F $HOME/.ssh/config" \
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
