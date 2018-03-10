#!/bin/sh
packages="openssh-server ntpdate bash-completion nano ntp ntpdate nmap tcpdump bmon 
git-core subversion rsync build-essential watchdog screen avahi-daemon"

if [ x$1 != x ] ; then
	export http_proxy=$1
fi

# Update apt and then install additional packages
sudo -E apt-get update

# Update apt and then install additional packages
sudo -E apt-get -y install $packages
sudo -E apt-get -y dist-upgrade
sudo -E apt-get -y autoremove
sudo -E apt-get clean

# Set the time and enable ntp on boot
sudo ntpdate 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org
sudo update-rc.d ntp enable

# Enable watchdog
sudo update-rc.d watchdog enable

# Enable some more modules
echo "
# load the on die watch driver
bcm2708_wdog
# load the on die RNG
bcm2708-rng
" | sudo tee /etc/modules

# Install my personal ssh key
mkdir -p $HOME/.ssh/
if ! grep -q "$key" $HOME/.ssh/authorized_keys ; then
	echo "# My personal key" | tee -a $HOME/.ssh/authorized_keys
	echo "$key" | tee -a $HOME/.ssh/authorized_keys
fi
