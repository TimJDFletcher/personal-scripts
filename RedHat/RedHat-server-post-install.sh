#!/bin/sh
workkeyurl="http://co-lo.night-shade.org.uk/~tim/ID/brigher-dsa.pub"
personalkeyurl="http://co-lo.night-shade.org.uk/~tim/ID/personal-dsa.pub"
packages="lm_sensors openssh-server ntp smartmontools bash-completion nano acpid"
epel=true
epel_version=8
arch=$(uname -m)
redhat_version=6

if [ x$1 != x ] ; then
	export http_proxy=$1
fi

if [ x$epel = xtrue ] ; then
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/$arch/epel-release-$redhat_version-$epel_version.noarch.rpm
	rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
fi

# Update apt and then install additional packages
yum update
yum install $packages
yum clean packages

# Enable ACPI management
chkconfig acpid on
service acpid retart

# Set the time and enable ntp on boot
ntpdate 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org
hwclock --systohc
chkconfig ntpd on
chkconfig ntpdate on

# Install my personal ssh key
mkdir -p $HOME/.ssh/
curl $workkeyurl >> $HOME/.ssh/authorized_keys

# Fix bloody selinux
restorecon -R $HOME/.ssh
