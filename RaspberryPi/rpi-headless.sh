#!/bin/bash -e
TARGET=/Volumes/boot
[ -d $TARGET ]
touch $TARGET/ssh
ssh pi-zero.local sudo cat /etc/wpa_supplicant/wpa_supplicant.conf > $TARGET/wpa_supplicant.conf
