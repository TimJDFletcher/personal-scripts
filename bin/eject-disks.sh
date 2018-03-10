#!/bin/sh
DISKS="TimeMachine MobileBackups TOSHIBAFAT Toshiba.HFS+"
for DISK in $DISKS ; do
    diskutil eject $DISK
done
