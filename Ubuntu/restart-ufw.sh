#!/bin/sh
sudo iptables -F -t mangle
sudo iptables -F -t nat
sudo iptables -F
sudo iptables -X
sudo service ufw restart
