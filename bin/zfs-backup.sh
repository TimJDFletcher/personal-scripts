#!/bin/bash -e
HOST=${1:-boron-vpn}
POOL=boron
TARGET=backups/macbook
SOURCE=
USER=root

caffeinate sudo -E rsync \
    --rsh "ssh -F $HOME/.ssh/config" \
    --compress \
    --archive \
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
