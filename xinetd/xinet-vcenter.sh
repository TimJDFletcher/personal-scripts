#!/bin/sh
ports="80 443 8080 902 8443 9443"
target=10.20.110.145
localip=172.17.0.42

for port in $ports ; do
echo "service vcenter__PORT_ 
{
          port = _PORT_
          disable = no
          socket_type = stream
          type = UNLISTED
          protocol = tcp
          wait = no
          user = nobody
          redirect = _TARGET_ _PORT_ 
}" | sed -e "s/_PORT_/$port/g" -e "s/_LOCALIP_/$localip/g" -e "s/_TARGET_/$target/g"
done
