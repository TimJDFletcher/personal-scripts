#!/bin/sh
esxiversion=5.0latest
ubuntuversion=precise
# ubuntuversion=$(lsb_release -cs)

echo deb http://packages.vmware.com/tools/esx/${esxiversion}/ubuntu $ubuntuversion main | \
sudo tee /etc/apt/sources.list.d/vmware.list

wget http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub -q -O- | \
sudo apt-key add -

sudo aptitude update 
sudo aptitude install vmware-tools-esx

