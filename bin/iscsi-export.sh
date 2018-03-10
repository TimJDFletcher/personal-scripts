#!/bin/sh
targetname=backups.local
tid=$(cat /proc/net/iet/volume | grep $targetname | awk '{print $1}' | cut -d : -f 2)
sudo blockdev --setrw $1
sudo ietadm --op new --lun=0 --tid=$tid --params Path=$1,Type=fileio,IOMode=wb
