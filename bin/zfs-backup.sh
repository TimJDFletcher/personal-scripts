#!/bin/bash -e
HOST=oxygen
POOL=WDZBA365
TARGET=backups/cubits
SOURCE=
USER=root

caffeinate sudo -E rsync \
    --rsh "ssh -F $HOME/.ssh/config" \
    --archive \
    --hard-links \
    --partial \
    --progress \
    --one-file-system \
    --ignore-errors \
    --inplace \
    --delete \
    --delete-after \
    $SOURCE/ $USER@$HOST:/$POOL/$TARGET/
