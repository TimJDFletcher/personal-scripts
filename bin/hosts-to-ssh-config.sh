#!/bin/bash
cat $1 | grep -v '^$' | grep -v '#'| while read ip host ; do 
    echo "host $host"
    echo "  hostname $ip"
done
