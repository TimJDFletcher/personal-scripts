#!/bin/sh

snap_rename()
{
newname=$(echo $1 | sed -e s/frequent/manual/g)
if [ "x$newname" != "x$1" ] ; then
	zfs rename $1 ${newname}
fi
}

for snap in $(zfs list -t snap | grep ^backups/laptop | awk '{print $1}' ) ; do
	snap_rename $snap
done
