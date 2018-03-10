#!/bin/sh
pkill -9 pinentry-mac
pkill -9 scdaemon
echo UPDATESTARTUPTTY | gpg-connect-agent

