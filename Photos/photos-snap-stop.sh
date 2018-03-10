#!/bin/sh
sudo initctl stop smbd
sleep 10
sudo umount /exports/photos/
sync
sudo lvremove /dev/mapper/raid5-photos.snap 
sudo initctl start smbd
