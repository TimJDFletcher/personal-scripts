#!/bin/sh
switches="missionas02.adm missionas06.adm missionas07.adm hadfieldas01.adm"
coreswitches="missioncs01.adm missioncs02.adm"
aps="missionap1.adm missionap2.adm"
routers="missioncr01.adm custvpn1.wems.co.uk custvpn2.wems.co.uk"
gpgbackupdir=$HOME/WEMS/Cisco/ios-backup
gitbackupdir=$HOME/WEMS/infrastructure-configs/Cisco
date=$(date +%s)
gpgkey=E22C70C4
username=tfletcher

echo -n "Cisco password: "
stty -echo ; read SSHPASS ; stty echo
export SSHPASS

for device in $coreswitches $switches $aps $routers ; do
    # Copy startup and running config to git repo
    mkdir -p $gitbackupdir/$device
    sshpass -e scp $username@$device:running-config $gitbackupdir/$device/running-config
    sshpass -e scp $username@$device:startup-config $gitbackupdir/$device/startup-config
    # Encrypt copy of config to Dropbox
    mkdir -p $gpgbackupdir/$device
    gpg -e -r $gpgkey --output $gpgbackupdir/$device/running-config-$date.gpg $gitbackupdir/$device/running-config
    gpg -e -r $gpgkey --output $gpgbackupdir/$device/startup-config-$date.gpg $gitbackupdir/$device/startup-config
done

cd $gitbackupdir
git add .
git commit -m "Config backup from $(date)"
git push
