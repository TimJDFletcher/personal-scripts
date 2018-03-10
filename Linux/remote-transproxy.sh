#!/bin/sh
cacheserver=192.168.1.2
cacheport=3128
wwwports=80

fwmark=3
routing_table=2
dev=br0

stop()
{
/sbin/ip rule  del fwmark $fwmark table $routing_table
/sbin/ip route del table $routing_table
for port in $wwwports; do
	/sbin/iptables -t mangle -D PREROUTING -j ACCEPT -p tcp --dport $port -s $cacheserver
	/sbin/iptables -t mangle -D PREROUTING -j MARK --set-mark 3 -p tcp --dport $port
done
}

start()
{
/sbin/ip rule  add fwmark $fwmark table $routing_table
/sbin/ip route add default via $cacheserver dev $dev table $routing_table
for port in $wwwports; do
	/sbin/iptables -t mangle -A PREROUTING -j ACCEPT -p tcp --dport $port -s $cacheserver
	/sbin/iptables -t mangle -A PREROUTING -j MARK --set-mark 3 -p tcp --dport $port
done
}

case $1 in
stop)
	stop
;;
start)
	start
;;
restart)
	stop
	start
;;
esac
