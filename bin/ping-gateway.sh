#!/bin/sh
while true ; do
    gateway=$(route -n get default 2>/dev/null | grep gateway | awk '{print $NF}')
    if [ x=x$gateway ] ; then
        ping -W 10 -t 60 -i 5 $gateway
    else
        echo No gateway found
    fi
    sleep 1
done
