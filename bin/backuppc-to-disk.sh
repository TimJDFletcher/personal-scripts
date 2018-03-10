#!/bin/sh

dobackup()
{
srclv=$1
dst=$2
vgname=$4

# blkid here?
sudo lvremove --force /dev/$vgname/${lvmsrc}.snap
sudo lvcreate -L 20G -s -n ${lvmsrc}.snap /dev/$vgname/$lvmsrc
sudo ddrescue /dev/$vgname/${lvmsrc}.snap /dev/mapper/$dst

}

sudo cryptdisks_start backups.system
sudo cryptdisks_stop backups.system

