#!/bin/sh
switch=eth0

swconfig dev $switch set reset 1
swconfig dev $switch set apply 1
sleep 2
swconfig dev $switch set enable_vlan 1
# swconfig dev $switch set trunk 1

# set port vlan settings
swconfig dev $switch vlan 1 set ports '5t 3t'
swconfig dev $switch vlan 2 set ports '5t 2t'
swconfig dev $switch vlan 3 set ports '5t 1t'
swconfig dev $switch vlan 4 set ports '5t 0t'

swconfig dev $switch vlan 1 set ports '5t 3'
swconfig dev $switch vlan 2 set ports '5t 2'
swconfig dev $switch vlan 3 set ports '5t 1'
swconfig dev $switch vlan 4 set ports '5t 0'

swconfig dev $switch vlan 0 set ports '5t'
swconfig dev $switch vlan 5 set ports '5t'

# set untagged vlan ports to correct PVID
#swconfig dev $switch port 0 set pvid 4
#swconfig dev $switch port 1 set pvid 3
#swconfig dev $switch port 2 set pvid 2
#swconfig dev $switch port 3 set pvid 1

# is this necessary?
swconfig dev $switch set apply 1

swconfig dev $switch show
