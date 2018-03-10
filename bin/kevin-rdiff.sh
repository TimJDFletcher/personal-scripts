#!/bin/sh
remoteuser=root
sshkey=benj-vm.id_rsa
retention=28D

# Backup Kevin's VPS
remotehost=kevin-vps
localtarget=/backups/kev/rdiff
precommand=/usr/local/bin/plesk-mysql-backup.sh

if ssh $remoteuser@$remotehost $precommand ; then
	rdiff-backup --force --remove-older-than "$retention" $localtarget/
	rdiff-backup --exclude-other-filesystems $remoteuser@$remotehost::/ $localtarget/
else
	echo $precommand failed
fi
