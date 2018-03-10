#!/bin/sh
hostname=82.71.218.202
ssh $hostname python /usr/src/git/gfwlist2dnsmasq/gfwlist2dnsmasq.py
scp $hostname:/usr/src/git/gfwlist2dnsmasq/dnsmasq_list.conf /tmp/
scp /tmp/dnsmasq_list.conf wt3020:/var/etc/dnsmasq_gfw_list.conf
ssh wt3020 /etc/init.d/dnsmasq restart
