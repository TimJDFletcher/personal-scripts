#!/bin/sh
cd "$1"
rm autorun.inf
mkdir autorun.inf
touch autorun.inf/lock
chmod 0000 autorun.inf/lock
chmod 0000 autorun.inf
chmod a-w autorun.inf/lock
chmod a-w autorun.inf
chattr +i autorun.inf/lock
chattr +i autorun.inf
cd -
