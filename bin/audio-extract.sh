#!/bin/sh
ffmpeg -i "$1" -acodec libmp3lame -ab 192k "$1".mp3
ffmpeg -i "$1" -acodec pcm_s16le -ac 2  "$1".wav

