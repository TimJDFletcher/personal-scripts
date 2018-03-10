#!/bin/sh
drives="
scsi-SATA_OCZ-REVODRIVE3_OCZ-D6Z7V461HW8UILB3
scsi-SATA_OCZ-REVODRIVE3_OCZ-S7N03H4QT1958QS8
scsi-SATA_ST500DM002-1BD1_Z2ASWYC8
scsi-SATA_ST500DM002-1BD1_Z2ASWYE6
scsi-SATA_ST500DM002-1BD1_Z2ASWYRE
scsi-SATA_ST500DM002-1BD1_Z2ASWYY2
usb-Samsung_M3_Portable_00000000011E192D-0:0
usb-Samsung_M3_Portable_00000000011E216F-0:0
"

raiduuids="
35b6705f:ec295699:6eb3d0db:464c8620
6a901932:536cf4b5:ff10b190:4da2bf40
857b12f9:59ef04bc:facd8f82:6f540e53
"

for drive in $drives ; do
	dev=$(udevadm info -q name -n /dev/disk/by-id/$drive)
	sudo smartctl -l scterc,70,70 /dev/$dev
	sudo hdparm -S 120 /dev/$dev
	sudo hdparm -B 255 /dev/$dev
	sudo sh -c "echo 1024 > /sys/block/$dev/queue/read_ahead_kb"
	sudo sh -c "echo 1024 > /sys/block/$dev/queue/nr_requests"
	sudo sh -c "echo noop > /sys/block/$dev/queue/scheduler"
done

for uuid in $raiduuids ; do
	dev=$(udevadm info -q name -n /dev/disk/by-id/md-uuid-$uuid)
	sudo sh -c "echo 8192 > /sys/block/$dev/queue/read_ahead_kb"
	sudo sh -c "echo noop > /sys/block/$dev/queue/scheduler"
done

