#!/bin/bash
set -eu -o pipefail
HOST="${1:-tim@oxygen.vpn.night-shade.org.uk}"
TARGET_DIR="${2:-/WDZBA365/media/transmission/downloads/complete}"
SRC_DIR=/media/tv
SYNC_DAYS=30

_rsync()
{
    echo "Copying TV from ${1} to ${HOST}:${TARGET_DIR}"
        rsync \
            --recursive \
            --size-only \
            --verbose \
            --progress \
            --bwlimit 600K \
            --temp-dir ../incomplete \
            --from0 \
            --files-from=<(find "${1}" -ctime -${SYNC_DAYS} -type f \( -iname \*.mp4 -o -iname \*.mkv \) -print0) \
            . ${HOST}:${TARGET_DIR}

}

cat $HOME/tv.list | while read line ; do 
    if [ -d "$SRC_DIR/$line" ] ; then
        cd "$SRC_DIR"
        _rsync "${line}"
    else
        echo "Skipping $SRC_DIR/$line"
    fi
done
