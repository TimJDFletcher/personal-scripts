#!/bin/bash -e
TARGET=/Volumes/boot
[ -d $TARGET ]
touch $TARGET/ssh
gopass show wpa_supplicant.conf > $TARGET/wpa_supplicant.conf
