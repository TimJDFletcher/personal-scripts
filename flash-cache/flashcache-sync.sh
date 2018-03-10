#!/bin/sh
sync
find /proc/flashcache -maxdepth 1 -mindepth 1 -type d -printf "%f\n" |\
sed -e "s%\.%/%g" |\
xargs -I "%" -n 1 sudo sysctl -w "dev.flashcache.%.do_sync=1"
