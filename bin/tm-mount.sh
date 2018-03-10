#!/bin/bash
# Note use this command to hide: sudo SetFile -a V /Volumes/macOS-backups/
SHARENAME="TimeCapsule"
SERVERNAME=tim@carbon._smb._tcp.local
SPARSEBUNDLE=MacBook-acbc327a0eff.sparsebundle
loopcount=0

diskutil unmount force "/Volumes/$SHARENAME/$SPARSEBUNDLE"
diskutil unmount force "/Volumes/$SHARENAME"

while [ ! -d "/Volumes/$SHARENAME/$SPARSEBUNDLE" ] ; do 
    open -g "smb://$SERVERNAME/$SHARENAME"
    sleep 5
    loopcount=$((loopcount+1))
    if [ $loopcount -gt 10 ] ; then
        exit 1
    fi
done

set -e

# hdiutil compact "/Volumes/$SHARENAME/$SPARSEBUNDLE"
hdiutil attach -quiet -noautofsck -nobrowse "/Volumes/$SHARENAME/$SPARSEBUNDLE"  && tmutil startbackup -a
