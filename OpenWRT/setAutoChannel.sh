#!/bin/ash

# Basic Wi-Fi auto channel selector by PoweredLocal
# (c) 2017 PoweredLocal, Melbourne, Australia
# https://www.poweredlocal.com
#
# Denis Mysenko 20/07/2017
#
# Updated by
# Petrunin Alex 21/09/2017

# Config
TEST_INTERVAL=5
ITERATIONS=3

# No need to touch anything below, in most cases
if [[ -z $1 ]]; then
  echo "# Basic Wi-Fi auto channel selector by PoweredLocal"
  echo $0 [interface index]
  exit 1
fi

INTERFACE_INDEX=$1
SIGNAL=NO

scan() {

	CHANNEL_1=0
	CHANNEL_2=0
	CHANNEL_3=0
	CHANNEL_4=0
	CHANNEL_5=0
	CHANNEL_6=0
	CHANNEL_7=0
	CHANNEL_8=0
	CHANNEL_9=0
	CHANNEL_10=0
	CHANNEL_11=0

	/usr/sbin/iw wlan${INTERFACE_INDEX} scan | grep -E "primary channel|signal" | {
	while read line; do
		FIRST=`echo "$line" | awk '{ print $1 }'`
		if [[ "$FIRST" == "signal:" ]]; then
			#SIGNAL=`echo $line | awk '{ print ($2 < -60) ? "NO" : $2 }'`
			SIGNAL=`echo $line | awk '{ print $2 }'`
		fi

		if [[ "$FIRST" == "*" -a "$SIGNAL" != "NO" ]]; then
			CHANNEL=`echo "$line" | awk '{ print $4 }'`
			eval "CURRENT_VALUE=CHANNEL_$CHANNEL"
			eval "CURRENT_VALUE=$CURRENT_VALUE"
			SUM=$(( $CURRENT_VALUE + 1 ))
			eval "CHANNEL_${CHANNEL}=$SUM"
		fi
	done
	echo $CHANNEL_1 $CHANNEL_2 $CHANNEL_3 $CHANNEL_4 $CHANNEL_5 $CHANNEL_6 $CHANNEL_7 $CHANNEL_8 $CHANNEL_9 $CHANNEL_10 $CHANNEL_11
	}
}

for ITERATION in $(seq 1 1 $ITERATIONS); do
	[[ -n $DEBUG ]] && echo Iteration $ITERATION
	RESULT=$(scan)
	echo $RESULT
	eval "RESULT_${ITERATION}_1=`echo $RESULT | awk '{ print $1 }'`"
	eval "RESULT_${ITERATION}_2=`echo $RESULT | awk '{ print $2 }'`"
	eval "RESULT_${ITERATION}_3=`echo $RESULT | awk '{ print $3 }'`"
	eval "RESULT_${ITERATION}_4=`echo $RESULT | awk '{ print $4 }'`"
	eval "RESULT_${ITERATION}_5=`echo $RESULT | awk '{ print $5 }'`"
	eval "RESULT_${ITERATION}_6=`echo $RESULT | awk '{ print $6 }'`"
	eval "RESULT_${ITERATION}_7=`echo $RESULT | awk '{ print $7 }'`"
	eval "RESULT_${ITERATION}_8=`echo $RESULT | awk '{ print $8 }'`"
	eval "RESULT_${ITERATION}_9=`echo $RESULT | awk '{ print $9 }'`"
	eval "RESULT_${ITERATION}_10=`echo $RESULT | awk '{ print $10 }'`"
	eval "RESULT_${ITERATION}_11=`echo $RESULT | awk '{ print $11 }'`"
	[[ $ITERATION -lt $ITERATIONS ]] && sleep $TEST_INTERVAL
done

for ITERATION in $(seq 1 1 $ITERATIONS); do
	for CHANNEL in $(seq 1 11); do
		eval "CURRENT_VALUE=RESULT_${ITERATION}_${CHANNEL}"
		eval "CURRENT_VALUE=$CURRENT_VALUE"
		eval "CURRENT_AVG=AVG_$CHANNEL"
		eval "CURRENT_AVG=$CURRENT_AVG"
		eval "AVG_$CHANNEL=$(( ($CURRENT_AVG + $CURRENT_VALUE + 1) / 2 ))"

		[[ $ITERATION -eq $ITERATIONS -a -n $DEBUG ]] && echo Channel $CHANNEL has an average of $(( ($CURRENT_AVG + $CURRENT_VALUE + 1) / 2 )) networks
	done
done

#process crossing 2.4Ghz channels

AVG_1=$(( $AVG_1+$AVG_2+$AVG_3+$AVG_4+$AVG_5 ))
AVG_11=$(( $AVG_11+$AVG_10+$AVG_9+$AVG_8+$AVG_7 ))
AVG_6=$(( $AVG_2+$AVG_3+$AVG_4+$AVG_5+$AVG_6+$AVG_7+$AVG_8+$AVG_9+$AVG_10 ))

echo Crossing channels for 1\\6\\11 channels - $AVG_1 $AVG_6 $AVG_11

if [ $AVG_1 -le $AVG_6 -a $AVG_1 -le $AVG_11 ]; then
	CHANNEL=1
elif [ $AVG_6 -le $AVG_1 -a $AVG_6 -le $AVG_11 ]; then
	CHANNEL=6
elif [ $AVG_11 -le $AVG_1 -a $AVG_11 -le $AVG_6 ]; then
	CHANNEL=11
fi

if [[ -n "$CHANNEL" ]]; then
	echo Setting channel to $CHANNEL
	/sbin/uci set wireless.radio${INTERFACE_INDEX}.channel="$CHANNEL"
	/sbin/uci commit
	/sbin/wifi reload //apply new settings
fi
