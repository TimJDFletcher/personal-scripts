#!/bin/sh
key="ssh-dss AAAAB3NzaC1kc3MAAACBANnPy1THmYBBVhwWz0419JEL2jEtUsOYkBN0hpxgeJbU/vbv1qZQKb5I8vtSV1ebeHBUr4AklN0KiRcA7o7N5uicD+V7CAdoqs6kFESF8i4o5ss4SOu+pTaGC+Ke9w9KQKubFO7PRmd5PA+Vd2XIjsHlMEeazPM/mnc/d+ZWzhftAAAAFQDyr28YOsaQ+OEDdb/pDIRuEguTOQAAAIBFTE0Ba2dveqfd2J7DJ2Nl36w8lYVX1OySmG272g/i3sOd6TD4MQ/x9zT2Nwf9n8yjeXIn2mtpbUCH2Hvwq1/Q52xDtQlkug8zPEusis4K+/gupLBEDDS69RujDfWNMM4trAlSMPmutnZZqOg5ikdoTZD6ZSPFwyrfmpkTwRQhmQAAAIEAnqLT7YrYSdGcEmpa4RPbmF4DWwSqP6ur+1oTiKydDWA0J/j23vx6a49ws0lL0GO+ztEcsNbGJ1VvrPfvTGS35qxR2MIjOD+f2MAc0ETUxUd/zRIwwQsW4ZlNb6v/0tO7BHdL/b7+Yfr0RXr6Yg5ATbbMqwStD8k3EiCiyiVlwkw= tim@night-shade.org.uk"

packages="clamav mplayer vlc ubuntu-restricted-extras lm-sensors 
openssh-server ntp smartmontools squid-deb-proxy-client"
remove_packages="unity-lens-shopping"

if [ x$1 != x ] ; then
	export http_proxy=$1
fi


# Set the time
sudo ntpdate 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org
sudo hwclock --systohc

# Enable mediabuntu sources
sudo -E wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list 
sudo -E apt-get update
sudo -E apt-get --yes --allow-unauthenticated install medibuntu-keyring
sudo -E apt-get update

# Install addons and then update
sudo -E apt-get --yes install $packages
# Remove packages
sudo -E apt-get --yes remove $remove_packages

case $(uname -i) in
x86_64)
	sudo -E apt-get --yes install w64codecs
;;
i386)
	sudo -E apt-get --yes install w32codecs
;;
*)
	echo Unknown platform skipping codec install
;;
esac

# Update
sudo -E apt-get --yes dist-upgrade
sudo -E apt-get --yes autoclean

mkdir $HOME/.ssh/
echo $key > $HOME/.ssh/authorized_keys
