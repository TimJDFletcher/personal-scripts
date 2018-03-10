#!/bin/sh
key="ssh-dss AAAAB3NzaC1kc3MAAACBANnPy1THmYBBVhwWz0419JEL2jEtUsOYkBN0hpxgeJbU/vbv1qZQKb5I8vtSV1ebeHBUr4AklN0KiRcA7o7N5uicD+V7CAdoqs6kFESF8i4o5ss4SOu+pTaGC+Ke9w9KQKubFO7PRmd5PA+Vd2XIjsHlMEeazPM/mnc/d+ZWzhftAAAAFQDyr28YOsaQ+OEDdb/pDIRuEguTOQAAAIBFTE0Ba2dveqfd2J7DJ2Nl36w8lYVX1OySmG272g/i3sOd6TD4MQ/x9zT2Nwf9n8yjeXIn2mtpbUCH2Hvwq1/Q52xDtQlkug8zPEusis4K+/gupLBEDDS69RujDfWNMM4trAlSMPmutnZZqOg5ikdoTZD6ZSPFwyrfmpkTwRQhmQAAAIEAnqLT7YrYSdGcEmpa4RPbmF4DWwSqP6ur+1oTiKydDWA0J/j23vx6a49ws0lL0GO+ztEcsNbGJ1VvrPfvTGS35qxR2MIjOD+f2MAc0ETUxUd/zRIwwQsW4ZlNb6v/0tO7BHdL/b7+Yfr0RXr6Yg5ATbbMqwStD8k3EiCiyiVlwkw= tim@night-shade.org.uk"
packages="openssh-server bash-completion nano acpid"
epel=true
epel_version=6-8
arch=$(uname -m)
redhat_version=6

if [ x$1 != x ] ; then
	export http_proxy=$1
fi

if [ x$rpmforge = xtrue ] ; then
	rpm -Uvh https://dl.fedoraproject.org/pub/epel/$redhat_version/$arch/epel-release-$epel_version.noarch.rpm
fi

# Update yum
yum install yum rpmforge-release

# Update and install additional packages
yum update
yum install $packages
yum clean packages

# Disable ntp on VM
chkconfig ntpd off
chkconfig ntpdate off

# Install my personal ssh key
mkdir -p $HOME/.ssh/
echo $key >> $HOME/.ssh/authorized_keys

# Fix bloody selinux
restorecon -R $HOME/.ssh
