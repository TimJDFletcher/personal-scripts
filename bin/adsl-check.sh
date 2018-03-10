#!/bin/sh
statefile=/var/state/adsl-fail-count
lockfile=/var/run/$(basename $0)
locktime=300
time=$(date +%s)
count=$(cat $statefile)
lastruntime=$(date +%s -r $statefile)
maxfail=3

testcmd()
{
	curl -s http://www.google.com > /dev/null ; export exit=$?
}

resetcmd()
{ 
	logger -t adsl-check $testcmd failed $maxfail times, reseting ADSL
	dsl-320t-reboot
	sleep 20
	dsl-320t-route-fix
}

if [ -f $lockfile ] ; then
	if [ $time -lt $(($time-$locktime)) ] ; then
		echo Lock file over $locktime seconds old, assuming something has broken and reseting
		count=0
		resetcmd
		exit=$?
	else
		echo I already appear to be running, remove $lockfile if this is wrong
		exit 1
	fi
fi

#Touch the lockfile
touch $lockfile

#Test the net connection - need to be sure that google keeps pinging
testcmd

if [ $exit -gt 0 ] ; then
	count=$((count+1))
	logger -t adsl-check present failure count is $count
else
	count=0
fi

if [ $count -gt $maxfail ] ; then
	count=0
	resetcmd
fi

echo $count > $statefile
rm -f $lockfile
exit $exit
