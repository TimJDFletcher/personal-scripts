#!/bin/sh
switches="missionas02.adm missionas03.adm missionas06.adm missionas07.adm missionas08.adm missionas09.adm missionas10.adm missioncs01.adm missioncs02.adm missioncs01.adm missioncs02.adm"
aps="missionap1.adm missionap2.adm"
routers="missioncr01.adm vpn2.wems.co.uk"
backupdir=ios-backup

echo -n "Cisco password: "
stty -echo ; read SSHPASS ; stty echo
export SSHPASS

for device in $switches $aps $routers ; do
	mkdir -p $backupdir/$device
	cat cisco-enablescp.txt | sshpass -e ssh -o PubKeyAuthentication=no -T $device
done
