#!/bin/sh
dom=$1
backuppath=/backup/nfs/libvirt/$dom

virsh shutdown $dom
sleep 1m
virsh define $backuppath/$dom.xml
sleep 5
virsh start $dom

