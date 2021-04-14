#!/bin/bash
for i in $(seq 0 255) ; do
    for x in $(seq 0 16 ) ; do 
        ssh-keygen -R 192.168.$x.$i 2> /dev/null
    done
    for x in $(seq 16 19 ) ; do 
        ssh-keygen -R 172.16.$x.$i 2> /dev/null
    done
done
