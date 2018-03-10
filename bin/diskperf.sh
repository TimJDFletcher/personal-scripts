#!/bin/sh
for i in $* ; do 
        sudo sh -c "echo 1024  > /sys/block/sd$i/queue/nr_requests"
        sudo sh -c "echo 1024 > /sys/block/sd$i/queue/read_ahead_kb"
        sudo sh -c "echo deadline > /sys/block/sd$i/queue/scheduler"
        sudo hdparm -W 1 /dev/sd$i
done

