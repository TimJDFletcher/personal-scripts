#!/bin/sh
ssl_support="ca-bundle ca-certificates"
packages="avahi-daemon-service-ssh bmon etherwake tor sqm-scripts ipset ${ssl_support}"
services="tor sqm"

set -e -u

if [ -f /.install.completed ]; then
  echo Install already completed
  exit 0
fi

opkg update
opkg install ${packages}

for service in $services; do
  /etc/init.d/${service} enable
  /etc/init.d/${service} start
done

/etc/init.d/firewall restart

touch /.install.completed
