#!/bin/bash
DIR=.
wfind $DIR -type f -print0 |\
    sort -R -z|\
    xargs -0 $HOME/Applications/VLC.app/Contents/MacOS/VLC
