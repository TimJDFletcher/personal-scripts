#!/bin/sh
keep_daily=7
keep_weekly=4
keep_monthly=12
keep_yearly=1
# Keep 7 daily snapshots
keep_total=$((keep_daily+keep_weekly+keep_monthly+keep_yearly))

dayofweek=$(date +%u)
dayofmonth=$(date +%d)
monthofyear=$(date +%m)

deleteoldest()
{
/sbin/zfs destroy $(/sbin/zfs list -t snapshot| grep ^archives/backups@$1| awk '{print $1}' | sort -n | tail -n 1)
}

latestsnap=$(/sbin/zfs list -t snapshot| grep ^archives/backups@| awk '{print $1}' | grep daily | sort -n | tail -n 1)
if [ "$dayofweek" = "7" ] ; then
	echo promoting daily to weekly snapshot
	/sbin/zfs rename $latestsnap $(echo $latestsnap| sed -e s/daily/weekly/g)
fi

latestsnap=$(/sbin/zfs list -t snapshot| grep ^archives/backups@| awk '{print $1}' | grep daily | sort -n | tail -n 1)
if [ "$dayofmonth" = "01" ] ; then
	if [ "$monthofyear" = "01" ] ; then
		echo promoting daily to yearly snapshot
		/sbin/zfs rename $latestsnap $(echo $latestsnap| sed -e s/daily/yearly/g)

	else
		echo promoting daily to monthly snapshot
		/sbin/zfs rename $latestsnap $(echo $latestsnap| sed -e s/daily/monthly/g)
	fi
fi

snapcount_total=$(/sbin/zfs list -t snapshot| grep -c ^archives/backups@)

# Don't bother trimming until we are over the max snapshots we are going to keep
#if [ $snapcount_total -le $keep_total ] ; then
#	exit 0
#fi

# loop down the list deleting the oldest backups until we fit the settings
for type in yearly monthly weekly daily ; do
	count=$(/sbin/zfs list -t snapshot| grep -c ^archives/backups@$type)
	keep=$(eval echo \$keep_$type)
	while [ $count -gt $keep ] ; do
		deleteoldest $type
		count=$(/sbin/zfs list -t snapshot| grep -c ^archives/backups@$type)
	done
done
