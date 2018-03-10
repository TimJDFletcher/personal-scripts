#!/bin/sh
if ! lsusb | grep -q 1050:011 ; then
    echo Yubi key not present
    exit 1
elif ssh-add -l  | grep -q cardno:000603020768 ; then
    echo ssh-add can see key, exiting
    exit 0
else
    echo Resetting scdaemon
    pkill -9 scdaemon
fi
