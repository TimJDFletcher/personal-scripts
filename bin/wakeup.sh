#!/bin/sh

# Set the mac address for each host
host1_mac=<mac address>
host1_name=<host name>
host2_mac=<mac address>
host2_name=<host name>

# How long does the host take to boot
boottime=120

# Which interface to send the WoL packets out of
interface=eth0

# Function to check if the host pings
pingcheck()
{
ping -w 5 -c 2 $1
export pingstatus=$?
}

case $1 in
	host1)
		sudo etherwake -i $interface $host1_mac
		sleep $boottime
		pingcheck $host1_name
		exit $pingstatus
	;;
	host2)
		sudo etherwake -i $interface $host2_mac
		sleep $boottime
		pingcheck $host2_name
		exit $pingstatus
	;;
	*)
		echo "Unknown machine $1"
		exit 1
	;;
esac

