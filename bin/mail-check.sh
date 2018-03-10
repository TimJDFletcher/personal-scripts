#!/bin/bash
set -x
TEMPFILE=$(mktemp /tmp/pslist.XXXXXX)
declare -a PROCESSORS=('/usr/sbin/dovecot' '/usr/sbin/spamd' '/usr/sbin/clamd' '/usr/lib/postfix/master' '/usr/bin/freshclam' '/usr/sbin/clamsmtpd');
declare -a SERVICES=('dovecot' 'spamassassin' 'clamav-daemon' 'postfix' 'clamav-freshclam' 'clamsmtp');
CHECKCOUNT=${#PROCESSORS[@]}
COUNT=0

ps -eo command:400 -o comm > $TEMPFILE
while [ $COUNT -lt $CHECKCOUNT ] ; do
	if ! grep -q ^${PROCESSORS[$COUNT]} $TEMPFILE ; then
		logger "Service ${SERVICES[$COUNT]} restarted"
		service ${SERVICES[$COUNT]} restart
	fi
	COUNT=$((COUNT+1))
done
rm $TEMPFILE
