#!/bin/sh
fileperms=644
dirperms=755
owner=tim
group=mediatomb

dirs="/archives/tv
/archives/radio
/archives/youtube
/archives/Windows
/archives/music"

for dir in $dirs ; do
	find $dir/ -type d -print0 | xargs -0 chmod $dirperms
	find $dir/ -type f -print0 | xargs -0 chmod $fileperms
	chown $owner.$group $dir/ -R
done
