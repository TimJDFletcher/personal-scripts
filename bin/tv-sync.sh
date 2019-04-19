#!/bin/bash
set -eu -o pipefail
HOST="tim@oxygen.vpn.night-shade.org.uk"
TARGET_DIR="/media/transmission/downloads/complete"
SRC_DIR=/media/tv

_rsync()
{
    echo "Copying TV from $PWD to ${HOST}:${TARGET_DIR}"
        rsync \
            --archive \
            --verbose \
            --progress \
            --filter="+ *.mkv" \
            --filter="+ *.mp4" \
            --filter="- *" \
            ${HOST}:${TARGET_DIR}
}

cat $HOME/tv.list | while read line ; do 
    cd "$SRC_DIR/$line/"
    _rsync
done
