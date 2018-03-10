#!/bin/sh
sudo tcpdump -nn -i eth0 -v -s 0 -c 1 'ether[20:2] == 0x2000' 

