#!/bin/sh
avconv -i "$1" -vn -acodec libmp3lame "$1".mp3
echo Ripped audio out of "$1" to "$1".mp3

