#!/bin/sh
hosts="82.71.24.37 82.71.54.222 82.69.120.91 82.71.51.95 82.71.54.59 82.71.55.215 82.71.51.66"
customer=FourSeasonsCare
aclstart=2046
mapstart=111
echo crypto keyring $customer-keyring
for host in $hosts ; do 
    echo -n "   pre-shared-key hostname $host key "
    pwgen -1 16
done
echo exit
for host in $hosts ; do
    echo "crypto isakmp profile $customer-$host"
    echo "  vrf $customer-vrf"
    echo "  keyring $customer-keyring"
    echo "  match identity host $host"
    echo "exit"
done
acl=$aclstart
for host in $hosts ; do
    echo "crypto dynamic-map $customer-$host 1"
    echo "  set isakmp-profile $customer-$host"
    echo "  match address $acl"
    echo "exit"
    acl=$((acl+1))
done
map=$mapstart
for host in $hosts ; do
    echo crypto map 81-145-178-39-map $mapid ipsec-isakmp dynamic $customer-$host
    map=$((map+1))
done
for host in $hosts ; do
    echo access-list $acl remark CryptoACL for $customer-$host
    acl=$((acl+1))
done

