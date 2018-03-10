#!/bin/sh
find /sys/class/scsi_host/host*/ -name scan -print0 | xargs -0 sudo sh -c 'echo "- - -" > %'
