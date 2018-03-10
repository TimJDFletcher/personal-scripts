#!/bin/sh
sleep_start=0130
sleep_end=0630
time=$(date +%H%M)
# Trigger higher speeds if our phones haven't been seen for 3600 seconds 
# (60 mins)
phonetime=3600

# Check if we are meant to be asleep
if [ $time -gt $sleep_start ] ; then
	if [ $time -lt $sleep_end ] ; then
		# Don't use the alternate Limits. (faster)
		echo Setting higher speed limits
		transmission-remote --no-alt-speed
		#echo Starting all torrents
		#transmission-remote -t all -s
		exit 0
	fi
fi

# Check if our phones are close by
if /usr/local/bin/phonecheck.sh $phonetime 1>/dev/null 2>&1 ; then
	# Use the alternate Limits.(slower)
	echo Setting lower speed limits
	transmission-remote --alt-speed
	#echo Pausing all torrents
	#transmission-remote -t all -S
	exit 0
else
	# Don't use the alternate Limits. (faster)
	echo Setting higher speed limits
	transmission-remote --no-alt-speed
	#echo Starting all torrents
	#transmission-remote -t all -s
	exit 0
fi
