#!/bin/sh
dir=/var/log/nfdump
external=150
internal=100

filter="in if $external and out if $internal"
echo "----------------------------------------------------------------------------"
echo "Top internal hosts by incoming traffic"
echo "----------------------------------------------------------------------------"
nfdump -R $dir/$(date +%Y/%m/%d) -s srcip/bytes "$filter"

filter="in if $internal and out if $external"
echo "----------------------------------------------------------------------------"
echo "Top internal hosts by outgoing traffic"
echo "----------------------------------------------------------------------------"
nfdump -R $dir/$(date +%Y/%m/%d) -s dstip/bytes "$filter"

