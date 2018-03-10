#!/bin/sh
label=U3.FAT
device=$(udevadm info -q name -n /dev/disk/by-label/$label)
target=$(grep $device /proc/mounts | awk '{print $2}')

sync="
Firmware
Windows/Applications/BasicApps
Windows/Applications/PortableApps
Windows/Applications/Utils
Windows/Licenses
Linux/Scripts
"

if [ ! -d $target ] ; then
	echo Target not found exiting
	exit 1
fi

# See if we are local or remote
if ping -q -w 10 -c 2 carbon.local ; then
	source=/archives/
else
	source=carbon:/archives/
fi

echo Syncing from $source to $target in 10 seconds
sleep 10

for dir in $sync ; do
	rsync -avzcPH --delete --modify-window=1 $source/$dir/ $target/$dir/
done
