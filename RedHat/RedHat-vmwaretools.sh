#!/bin/sh
vmwareversion=latest
#http://packages.vmware.com/tools/esx/latest/repos/vmware-tools-repo-RHEL6-9.4.5-1.el6.x86_64.rpm
#http://packages.vmware.com/tools/esx/latest/repos/vmware-tools-repo-RHEL6-9.4.5-1.el6.i686.rpm
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-DSA-KEY.pub
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub

echo "[vmware-tools]
name=VMware Tools
baseurl=http://packages.vmware.com/tools/esx/$vmwareversion/rhel6/\$basearch
enabled=1
gpgcheck=1" > /etc/yum.repos.d/vmware-tools.repo

yum -y install vmware-tools-core vmware-tools-esx-nox
