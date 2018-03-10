#!/bin/bash
ip=$2
hostname=$1
username=tfletcher
proxyhost=mysql1

cat $HOME/.ssh/config.d/em-template | sed \
    -e s/%username%/$username/ \
    -e s/%ip%/$ip/g \
    -e s/%proxy%/$proxyhost/g \
    -e s/%hostname%/$hostname/g > $HOME/.ssh/config.d/$hostname.conf
