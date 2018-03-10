#!/bin/sh
key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR2ph1WtiyyfCiRmlzqNOMPiLQQhDeeZ/U54rCQtC1kpXtNROCBT4UJt8hfyJwYLAmGYmvYXhcyIgEqDFZH+Q+lAyT39kXg2+CYzgZgUeN2zx3vVGSqs6nTW51rhI6FnF64bWdHhO7iT//0zAFAEJROM5wRumN2xlfpEigIVRQE7wAy+TYcER0lDnzCX4OtASP6cmrpp4oyPbnE7d6Z294GDwoelDNRLKybAeflDVcH99y8zoOjLS/V+vV7PbMgJQu7VKV/8LCuJzeoUQxk5+shwLcCOW5PKKFAmmIqGjqAmH0l5sVUqMsBkaP+BmL5gitSHteRlnERkp2syvyUblx tim@brighter-connections.com"
early_packages="squid-deb-proxy-client"
packages="lm-sensors openssh-server ntp smartmontools bash-completion 
nano python-software-properties software-properties-common acpid"

if [ x$1 != x ] ; then
	export http_proxy=$1
fi

# Update apt and then install additional packages
sudo -E apt-get update

# Install any early packages
sudo -E apt-get -y install $early_packages

# Update apt and then install additional packages
sudo -E apt-get -y install $packages
sudo -E apt-get -y dist-upgrade
sudo -E apt-get -y autoremove
sudo -E apt-get clean

# Set the time and enable ntp on boot
sudo ntpdate 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org
sudo hwclock --systohc
sudo update-rc.d ntp enable

# Install my personal ssh key
mkdir -p $HOME/.ssh/
echo $key >> $HOME/.ssh/authorized_keys
