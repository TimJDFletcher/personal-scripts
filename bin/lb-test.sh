#!/bin/bash
for ip in 18 21 52 54 55 ; do 
    if ! ping=$(ping -W 50  -c 1 172.23.132.$ip) ; then 
        echo
        echo $(date)
        echo $ping 
    fi 
done
