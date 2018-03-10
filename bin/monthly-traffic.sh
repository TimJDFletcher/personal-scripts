#!/bin/sh
dir=/var/log/nfdump
external=150
internal=100
vpn=140

filter="in if $external and out if $internal"
echo "----------------------------------------------------------------------------"
echo "Top internal hosts by incoming traffic"
echo "----------------------------------------------------------------------------"
nfdump -R $dir/$(date +%Y/%m) -s dstip/bytes "$filter"

filter="in if $internal and out if $external"
echo "----------------------------------------------------------------------------"
echo "Top internal hosts by outgoing traffic"
echo "----------------------------------------------------------------------------"
nfdump -R $dir/$(date +%Y/%m) -s srcip/bytes "$filter"

filter="in if $external"
echo "----------------------------------------------------------------------------"
echo "Top external hosts by incoming traffic"
echo "----------------------------------------------------------------------------"
nfdump -R $dir/$(date +%Y/%m) -s srcip/bytes "$filter"

filter="if $vpn"
echo "----------------------------------------------------------------------------"
echo "Top VPN traffic"
echo "----------------------------------------------------------------------------"
nfdump -R $dir/$(date +%Y/%m) -s srcip/bytes "$filter"
nfdump -R $dir/$(date +%Y/%m) -s dstip/bytes "$filter"
