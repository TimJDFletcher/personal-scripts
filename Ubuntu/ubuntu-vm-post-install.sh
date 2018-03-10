#!/bin/sh
key="ssh-dss AAAAB3NzaC1kc3MAAACBANnPy1THmYBBVhwWz0419JEL2jEtUsOYkBN0hpxgeJbU/vbv1qZQKb5I8vtSV1ebeHBUr4AklN0KiRcA7o7N5uicD+V7CAdoqs6kFESF8i4o5ss4SOu+pTaGC+Ke9w9KQKubFO7PRmd5PA+Vd2XIjsHlMEeazPM/mnc/d+ZWzhftAAAAFQDyr28YOsaQ+OEDdb/pDIRuEguTOQAAAIBFTE0Ba2dveqfd2J7DJ2Nl36w8lYVX1OySmG272g/i3sOd6TD4MQ/x9zT2Nwf9n8yjeXIn2mtpbUCH2Hvwq1/Q52xDtQlkug8zPEusis4K+/gupLBEDDS69RujDfWNMM4trAlSMPmutnZZqOg5ikdoTZD6ZSPFwyrfmpkTwRQhmQAAAIEAnqLT7YrYSdGcEmpa4RPbmF4DWwSqP6ur+1oTiKydDWA0J/j23vx6a49ws0lL0GO+ztEcsNbGJ1VvrPfvTGS35qxR2MIjOD+f2MAc0ETUxUd/zRIwwQsW4ZlNb6v/0tO7BHdL/b7+Yfr0RXr6Yg5ATbbMqwStD8k3EiCiyiVlwkw= tim@night-shade.org.uk"
early_packages="squid-deb-proxy-client"
packages="openssh-server bash-completion nano python-software-properties acpid linux-image-extra-virtual"
scripts="ubuntu-update.sh"
scripts_url=http://carbon/scripts/Ubuntu

if [ x$1 != x ] ; then
	export http_proxy=$1
fi

# Install early package - a proxy finder
sudo -E apt-get update
sudo -E apt-get -y install $early_packages

# Update apt and then install additional packages
sudo -E apt-get update
sudo -E apt-get -y install $packages

# Install helper scripts
mkdir -p $HOME/bin
for script in $scripts ; do 
	wget $scripts_url/$script -O $HOME/bin/$script
	chmod 755 $HOME/bin/$script
done

# Install my personal ssh key
mkdir -p $HOME/.ssh/
echo $key >> $HOME/.ssh/authorized_keys

# Update
$HOME/bin/ubuntu-update.sh
