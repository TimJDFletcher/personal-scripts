#!/bin/sh
HOST=argon
IFACE=br-lan
ssh $HOST tcpdump -i $IFACE -s 0 -l -w - $* | dd of=$HOST.dump
