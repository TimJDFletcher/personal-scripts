#!/bin/sh
#host=tim-6460b.local
host=iron.local
port=$(virsh -c qemu+ssh://$host/system domdisplay $1 | cut -d "=" -f 2)
if [ x$port != x ] ; then
	echo "Connecting to spice server on $host:$port"
	spicec --host $host --port $port &
else
	echo "Failed to find spice connections details for $1"
	exit 1
fi

