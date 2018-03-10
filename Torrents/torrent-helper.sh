#!/bin/sh
remotedir=/archives/unsorted/transmission/torrents/
remotehost=carbon
securedelete=srm

case "$1" in
magnet:*)
	ssh $remotehost /usr/bin/transmission-remote -a "$1"
;;
/*)
	chmod 666 "$1"
	scp "$1" $remotehost:$remotedir
	$securedelete "$1"
;;
esac
