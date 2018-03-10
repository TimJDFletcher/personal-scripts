#!/bin/sh
tun_dev=tun0
int_dev=eth0
target=$1
ports="80 427 443 902 5988 5989 8000 8100"

sudo sysctl -q net.ipv4.conf.all.forwarding=0
for port in $ports ; do
	sudo iptables -A FORWARD -i $tun_dev -p tcp --dport $port -j ACCEPT
	sudo iptables -A PREROUTING -t nat -i $tun_dev -j DNAT -p tcp --dport $port --to $target:$port
done

sudo iptables -A POSTROUTING -t nat -o $int_dev -j MASQUERADE

for dev in $int_dev $tun_dev ; do
       sudo sysctl -q net.ipv4.conf.$dev.forwarding=1
done

