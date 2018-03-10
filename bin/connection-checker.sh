#!/bin/sh
PATH="/usr/sbin:/usr/bin:/sbin:/bin"

cronfile=/etc/cron.d/connectionchecker
logname=$(basename $0 .sh)
statefile=/var/run/$logname
lockfile=/var/run/${logname}.lock
locktime=300
maxfail=3
time=$(date +%s)

if [ -f $statefile ] ; then
	count=$(cat $statefile)
	lastruntime=$(date +%s -r $statefile)
else
	count=1
	lastruntime=$time
fi

testcmd()
{
	wget -q http://carbon/ -O /dev/null ; export exit=$?
}

cronsetup()
{
	echo "*/10 * * * * root $0" > $cronfile
}

resetcmd()
{
#	ifdown wlan0
#	sleep 10s
#	killall wpa_supplicant
#	sleep 10s
#	ifup wlan0
echo reseting
}

case $1 in
setup)
	echo setting up crontab in $cronfile
	chmod 755 $0
	cronsetup
	exit 0
;;
failtest)
	echo testing reset process
	resetcmd
;;
esac

if [ -f $lockfile ] ; then
	if [ $time -gt $(($time-$locktime)) ] ; then
		logger -t $logname Lock file over $locktime seconds old, assuming something has broken calling reset
		count=0
		resetcmd
		exit=$?
	else
		echo I already appear to be running, remove $lockfile if this is wrong
		exit 1
	fi
fi

# Touch the lockfile
touch $lockfile

# Test the wireless connection
testcmd

if [ $exit -gt 0 ] ; then
	count=$((count+1))
	logger -t $logname present failure count is $count
else
	count=0
fi

if [ $count -ge $maxfail ] ; then
	count=0
	logger -t $logname Check failed $maxfail times, reseting connection
	resetcmd
fi

echo $count > $statefile
rm -f $lockfile
exit $exit
