#!/bin/sh
if [ -f /.install.completed ] ; then
	echo Install already completed
	exit 0
fi

services_disable="dnsmasq"
services_enable="zram"

for service in $services_disable ; do
	/etc/init.d/$service stop
	/etc/init.d/$service disable
done

opkg update
opkg install rsync nano tc ip bmon zram-swap


for service in $services_disable ; do
	/etc/init.d/$service stop
	/etc/init.d/$service disable
done

for service in $services_enable ; do
	/etc/init.d/$service enable
	/etc/init.d/$service start
done

touch /.install.completed

