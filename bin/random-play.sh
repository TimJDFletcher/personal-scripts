#!/bin/bash
DIR=.
CACHE=8192
find $DIR -type f -print0 | sort -R -z| xargs -0 mplayer -cache $CACHE $*
