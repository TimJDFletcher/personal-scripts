#!/bin/sh
switch=internal
ovs-vsctl add-port $switch $1
/sbin/ip link set $1 up
