#!/bin/bash

case $1 in
    dev)
        port=2020
        networks="172.23.130 172.23.131"
    ;;
    prod)
        port=2020
        networks="172.23.130 172.23.131"
    ;;
esac

for network in $networks ; do
    for ip in $(seq 0 255) ; do
        ssh-keygen -R [$network.$ip]:$port 2>/dev/null
    done
done
