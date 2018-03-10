#!/bin/sh
pagesize=$(getconf PAGESIZE)
shared=$(cat /sys/kernel/mm/ksm/pages_shared)
sharing=$(cat /sys/kernel/mm/ksm/pages_sharing)
unshared=$(cat /sys/kernel/mm/ksm/pages_unshared)

echo Total paged memory $(echo \($pagesize*\($sharing+$unshared\)\)/1048576 | bc)MB
echo Total shared pages $(echo $pagesize*$shared/1048576 | bc)MB
echo Saved memory $(echo $pagesize*$sharing/1048576 | bc)MB

