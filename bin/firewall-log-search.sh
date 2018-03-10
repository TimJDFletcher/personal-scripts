#!/bin/sh
logfile=192.168.1.1.log
logdir=/var/log/remote/$(date +%Y/%m/%d)
log=$logdir/$logfile
grep $1 $log

