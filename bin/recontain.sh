#!/bin/sh
avconv -i "$1" -vcodec copy -acodec copy "$1".mp4
