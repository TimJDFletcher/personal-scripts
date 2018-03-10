#!/bin/sh
router=vpn2.wems.co.uk
user=tfletcher
key=
crit=$3
warning=$2
count=$(ssh -tt $user@$router "show crypto session ivrf $1-vrf" 2>&1 | grep 'SAs:' | grep -cv 'SAs: 0' )
if [ $crit -ge $count ] ; then
    echo Critial failure only $count SAs present
    exit 1
elif [ $warning -ge $count ] ; then
    echo Warning only $count SAs present
    exit 1
else
    echo $count SAs present
    exit 0
fi
