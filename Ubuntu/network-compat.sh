#!/bin/bash
# Network Interface Script to bring Red Hat compatibility to Ubuntu
# Copyright (c) 2013 Matt Martz and Rackspace US, Inc.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

RES_COL=60
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
BOOTUP='color'
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
if [ "$CONSOLETYPE" = "serial" ]; then
	MOVE_TO_COL=
	BOOTUP='serial'
	SETCOLOR_SUCCESS=
	SETCOLOR_FAILURE=
	SETCOLOR_WARNING=
	SETCOLOR_NORMAL=
fi

echo_success() {
	[ "$BOOTUP" = "color" ] && $MOVE_TO_COL
	echo -n "["
	[ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
	echo -n $"  OK  "
	[ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
	echo -n "]"
	echo -ne "\r"
	return 0
}

echo_failure() {
	[ "$BOOTUP" = "color" ] && $MOVE_TO_COL
	echo -n "["
	[ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
	echo -n $"FAILED"
	[ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
	echo -n "]"
	echo -ne "\r"
	return 1
}

get_iface_list() {
	local IFACES
	IFACES=(`ifquery --list -e lo`)
	echo ${IFACES[*]}
}

order_array() {
	local IFACES=($@)
	IFACES=(`tr ' ' '\n' <<< "${IFACES[@]}" | sort -u`)
	echo ${IFACES[*]}
}

order_array_reverse() {
	local IFACES=($@)
	IFACES=(`tr ' ' '\n' <<< "${IFACES[@]}" | sort -ru`)
	echo ${IFACES[*]}
}

down_interfaces() {
	local IFACE rv1 rv2 rv3
	for IFACE in $(order_array `get_iface_list`); do
		echo -n "Shutting down interface $IFACE: "
		ifconfig $IFACE down && ifdown --force $IFACE
		rv1=$?
		[[ ! $IFACE =~ ^bond ]] && ip addr flush $IFACE || true
		rv2=$?
		[[ $rv1 = 0 && $rv2 = 0 ]] && echo_success || echo_failure
		echo
	done
	echo "Shutting down loopback interface: "
	ifconfig lo down && ifdown --force lo && ip addr flush lo || false
	rv=$?
	[ $rv = 0 ] && echo_success || echo_failure
	echo
}

up_interfaces() {
	echo "Bringing up loopback interface: "
	ifup lo
	[ $? = 0 ] && echo_success || echo_failure
	echo -n "Bringing up remaining interfaces: "
	# This prevents an issue where ifup blocks waiting for "slave"
	# interfaces or vice versa
	ifup -a -e lo -e bond &
	ifup -a -e lo -e eth
	[ $? = 0 ] && echo_success || echo_failure
	echo
}

# See how we were called.
case "$1" in
	start)
		[ "$EUID" != "0" ] && exit 4
		up_interfaces
		rc=$?
		;;
	stop)
		[ "$EUID" != "0" ] && exit 4
		down_interfaces
		rc=$?
		;;
	status)
		echo $"Configured devices:"
		echo lo `get_iface_list`

		echo $"Currently active devices:"
		/sbin/ip -o link show up | awk -F ": " '{ printf "%s ", $2 }'
		echo
		;;
	restart|reload|force-reload)
		[ "$EUID" != "0" ] && exit 4
		down_interfaces
		up_interfaces
		rc=$?
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|reload|force-reload}"
		exit 2
esac

exit $rc
