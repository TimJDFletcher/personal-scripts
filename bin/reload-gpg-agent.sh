#!/bin/sh
pkill -9 pinentry-mac
pkill -9 scdaemon
echo UPDATESTARTUPTTY | /usr/local/MacGPG2/bin/gpg-connect-agent

