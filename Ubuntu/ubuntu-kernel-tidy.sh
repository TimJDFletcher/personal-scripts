#!/bin/sh
runningversion=$(dpkg-query -W linux-image-`uname -r` | awk '{print $1}')
latestversion=$(dpkg-query -S /boot/vmlinuz* | cut -d ":" -f 1 | grep -vF $runningversion | tail -n 1)

dpkg-query -S /boot/vmlinuz-* | cut -d ":" -f 1 |\
grep -vF $runningversion |\
grep -vF $latestversion |\
awk '{print $1}' |\
xargs sudo apt-get -y purge
sudo apt-get autoremove
sudo apt-get autoclean
