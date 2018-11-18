#!/bin/bash
printf "Waiting: "
while ! ping -q -c 2 $1 2>/dev/null 1>/dev/null ; do
    sleep 10
    printf "."
done
echo " $1 is alive!" ; sleep 10
shift
exec $*
