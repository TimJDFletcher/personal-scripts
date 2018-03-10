#!/bin/sh
iface=eth0
source=195.195.168.0

start()
{
sudo iptables -t nat -I PREROUTING -p udp --source $source -i $iface --dport 53  -j REDIRECT --to-port 1194
sudo iptables -t nat -I PREROUTING -p tcp --source $source -i $iface --dport 443 -j REDIRECT --to-port 22
}

stop()
{
sudo iptables -t nat -D PREROUTING -p udp --source $source -i $iface --dport 53  -j REDIRECT --to-port 1194
sudo iptables -t nat -D PREROUTING -p tcp --source $source -i $iface --dport 443 -j REDIRECT --to-port 22
}

case $1 in
start)
	start
	;;
stop)
	stop
	;;
restart)
	stop
	start
	;;
*)
	echo "$0 stop/start/restart"
	exit 1
	;;
esac
