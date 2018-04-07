#!/bin/sh
IF=${1:-eth0}
sudo tcpdump -c 1000 -nn -i $IF -v -s 0 -c 1 'ether[20:2] == 0x2000' 
