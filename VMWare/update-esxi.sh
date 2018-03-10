#!/bin/sh
vcenter=vcenter.periodic.org.uk
hosts="esxi.periodic.org.uk vmware-vesxi1.periodic.org.uk vmware-vesxi2.periodic.org.uk"
version=ESXi-5.5.0-20140902001-standard
credstore=$(mktemp -u $HOME/.vmware/XXXXXXXX)
user=root

/usr/lib/vmware-vcli/apps/general/credstore_admin.pl --credstore $credstore add --username $user --server $vcenter

# Allow https from ESXi
# esxcli -s $vcenter --credstore $credstore --vihost $mainhost network firewall ruleset set -e true -r httpClient

# Check this zip for the latest profile
# https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/esx/vmw/vmw-ESXi-5.5.0-metadata.zip

# Print the latest version of ESXi 5.5 using a VMware host
# esxcli -s $vcenter --vihost $host software sources profile list -d https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml | egrep ^ESXi-5.5*standard | sort -n | tail -n 1 | awk '{print $1}'

for host in $hosts ; do
	# Allow https from ESXi
	esxcli -s $vcenter --credstore $credstore --vihost $host network firewall ruleset set -e true -r httpClient

	# Upgrade to the latest version of HP's VIBs
	# esxcli -s $vcenter --credstore $credstore --vihost $mainhost software vib install -d http://vibsdepot.hp.com/hpq/sep2014/index.xml

	# Upgrade to the latest version of ESXi
	esxcli -s $vcenter --credstore $credstore --vihost $host software profile update -d https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml -p $version
done

shred --remove $credstore
