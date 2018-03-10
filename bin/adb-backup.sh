#!/bin/sh
size=$(adb shell cat /proc/partitions | grep -w mmcblk0| awk '{print $3}')
adb forward tcp:5555 tcp:5555
adb shell mount /system
adb shell 'nohup /system/xbin/busybox nc -l -p 5555 -e /system/xbin/busybox dd
if=/dev/block/mmcblk0 &'
nc 127.0.0.1 5555 |  pv -s ${size}k -erp | pigz -c > /archives/mmcblk0.raw.gz
