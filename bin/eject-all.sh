#!/bin/sh
sync
osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'
#disks=$(diskutil list | grep '/dev/disk' | egrep -v 'disk0|disk1' | awk '{print $1}' | cut -d "/" -f 3)
#
#for disk in $disks ; do
#    diskutil eject $disk
#done
sync
