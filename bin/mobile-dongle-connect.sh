#!/bin/sh

# Settings for Vodafone
#export APN="internet"
#export USR="web"
#export PAS="web"

# Settings for Three UK
export APN="3internet"
export USR=""
export PAS=""

# export PIN="0000"

export IFNAME=hso0
export cfgdir=/etc/hso
DEVICE=/dev/ttyHS1
TMPFIL=$(mktemp /tmp/connect.XXXXXX)

up() {
	echo "Connecting"
	/bin/stty 19200 -tostop
	( /usr/sbin/chat -E -s -f $cfgdir/dial.cht <$DEVICE > $DEVICE ) 2>&1 | /usr/bin/tee $TMPFIL
	PIP="`grep '^_OWANDATA' $TMPFIL | cut -d, -f2`"
	NS1="`grep '^_OWANDATA' $TMPFIL | cut -d, -f4`"
	NS2="`grep '^_OWANDATA' $TMPFIL | cut -d, -f5`"
	echo "Connected $PIP"
	echo "Configuring $IFNAME"
	sudo /sbin/ip addr add $PIP/32 dev $IFNAME
	sudo /sbin/ip link set $IFNAME up
	echo "Adding default route via $IFNAME, "
	sudo /sbin/ip route del default
	sudo /sbin/ip route add default dev $IFNAME
	rm -f $TMPFIL
}

down() {
	echo Disconnecting
	/bin/stty 19200 -tostop
	/usr/sbin/chat -s -E -f $cfgdir/stop.cht <$DEVICE >$DEVICE
	sudo /sbin/ip link set $IFNAME down
	sudo /sbin/ip addr flush dev $IFNAME
	sudo /sbin/ip route del default dev $IFNAME
}

init() {
	echo Setting up modem on $IFNAME
	if [ x$PIN != x ] ; then
		/usr/sbin/chat -E -s -f $cfgdir/pin.cht <$DEVICE >$DEVICE
	fi
	/usr/sbin/chat -E -s -f $cfgdir/init.cht <$DEVICE >$DEVICE
}

usage() {
	echo "Usage: $0 (up|down|restart|init)"
}

case "$1" in
	up|start)
		up
		;;
	down|stop)
		down
		;;
	restart)
		down
		sleep 5
		init
		sleep 5
		up
		;;
	init)
		init
		;;
	*)
		usage
		;;
esac

