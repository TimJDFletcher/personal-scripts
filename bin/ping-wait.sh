#!/bin/sh
echo -n "Waiting: "
while ! ping -q -c 2 -w 10 $1 > /dev/null ; do
	sleep 10
	echo -n "."
done
echo " $1 is alive!"
shift
$*
