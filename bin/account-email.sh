#!/bin/sh
users="timothy.fletcher
rafael.benvenuti
arjun.naik
ivan.popovic"

for user in $users ; do
    password=$(pwgen -1 16)
    printf "$user - $password\n"
done
