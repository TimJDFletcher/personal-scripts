#!/bin/sh
router=vpn2.wems.co.uk
user=tfletcher
key=
vrfs=$(ssh -tt tfletcher@vpn2.wems.co.uk show vrf 2>/dev/null | grep 100:| awk '{print $1}')
for vrf in $vrfs ; do 
    count=$(ssh -tt $user@$router "show crypto session ivrf $vrf brief" 2>&1 | grep -c 'UA' )
    echo $vrf has $count sessions active
done
