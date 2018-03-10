#!/bin/sh
preconnect()
{
echo -n "Running precommand: $precommand"
if ssh $host "$precommand" ; then
	echo , success
	sleep 10
else
	echo , failed
	exit 1
fi
}

filecopy()
{
rsync \
--archive \
--inplace \
--no-whole-file \
--verbose \
--hard-links \
--fuzzy \
--partial \
--progress \
--delete-after \
--delete-excluded \
--exclude-from=$src/etc/photos.exclude \
$src/	\
$host:/$target
}

postconnect()
{
echo -n "Running postcommand: $postcommand"
if ssh $host "$postcommand" ; then
	echo , success
else
	echo , failed
	exit 1
fi
}
host=tim@iconnect
src=/photos
target=backups/photos
precommand="mount /$target"
postcommand="umount /$target"

preconnect
sleep 10
filecopy
sleep 10
postconnect

#target=iron/backups/photos
#host=tim@iron
#precommand="/bin/true"
#postcommand="sudo /sbin/zfs snapshot $target@sync-$(date +%Y%m%d%H%M)"

#preconnect
#filecopy
#postconnect
