#!/bin/sh
SOURCEDIR="$HOME/Pictures/Photos Library.photoslibrary/Masters"
TARGETDIR="/iscsi/photos/Working/Masters"
HOST=oxygen.local
rsync --delete -avPHS "$SOURCEDIR/" $HOST:$TARGETDIR/ 
