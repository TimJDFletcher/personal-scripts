#!/bin/sh

smartctl -l scterc,70,70 /dev/sd$1
hdparm -W 1 /dev/sd$1
echo 1024 > /sys/block/sd$1/queue/nr_requests
echo noop > /sys/block/sd$1/queue/scheduler

