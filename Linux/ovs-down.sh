#!/bin/sh
switch=internal
/sbin/ip link set $1 down
ovs-vsctl del-port ${switch} $1
