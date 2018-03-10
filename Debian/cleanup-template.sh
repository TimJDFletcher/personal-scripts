#!/bin/bash
set -e
histfiles="*.swp .bash_history .lesshst -.viminfo"

# Check we are running on a VMware box
if [ ! vmware-checkvm ] ; then
    echo Are you sure this is an VMware system?
    exit 1
elif [ $UID != 0 ] ; then
    echo Please run the script as root
    exit 1
fi

# Fully upgrade the system, then clean out cached packges
apt-get update
apt-get -y dist-upgrade
apt-get -y autoremove
find /var/cache/apt -type f -print0 | xargs -0 --no-run-if-empty rm -v

# Delete history files from /root and /home
for file in $histfiles ; do
    find /root /home -name "$file" -print0 | xargs -0 --no-run-if-empty rm -v
done

# Stop rsyslog and delete all log files
systemctl stop rsyslog.socket
systemctl stop rsyslog
find /var/log -type f -print0 | xargs -0 --no-run-if-empty rm -v
