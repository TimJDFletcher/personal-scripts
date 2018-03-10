#!/bin/sh
ports=$1
localip=$2
target=$3

skel='service _TARGET_-_PORT_\n{\n
\t port = _PORT_\n
\t bind = _LOCALIP_\n
\t disable = no\n
\t socket_type = stream\n
\t type = UNLISTED\n
\t protocol = tcp\n
\t wait = no\n
\t user = nobody\n
\t redirect = _TARGET_ _PORT_\n
}'

for port in $ports ; do
	echo $skel | sed -e s/_PORT_/$port/g -e s/_TARGET_/$target/g -e s/_LOCALIP_/$localip/g
done
