#!/bin/sh
iso=$1
target=ilo
sshcmd="ssh -l Administrator $target "
chars=$(echo $iso| wc -c)
maxchars=80

if [ $chars -gt $maxchars ] ; then
	echo $iso is longer than $maxchars characters
	exit 1
fi
$sshcmd "vm cdrom eject"
$sshcmd "vm cdrom insert $iso"
$sshcmd "vm cdrom set connect"
$sshcmd "vm cdrom set boot_once"
$sshcmd "vm cdrom get"
