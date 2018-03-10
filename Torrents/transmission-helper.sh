#!/bin/sh
remotedir=/archives/unsorted/transmission/torrents/
remotehost=carbon

env > /tmp/foo

case "$1" in
magnet:*)
ssh $remotehost /usr/bin/transmission-remote -a "$1"
;;
/*)
chmod 666 "$1"
scp "$1" $remotehost:$remotedir
shred --remove "$1"
;;
esac
