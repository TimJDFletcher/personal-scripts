#!/bin/bash
if [ $HOSTTYPE == x86_64 ] ; then
	INSTALLER="https://cygwin.com/setup-x86_64.exe"
else
	INSTALLER="https://cygwin.com/setup.exe"
fi
TMPFILE=$(mktemp $TMP/cygwin-setup-XXXXXX.exe)
wget $INSTALLER -O $TMPFILE
chmod 755 $TMPFILE
$TMPFILE
rm $TMPFILE
