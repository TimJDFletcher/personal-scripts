#!/bin/bash
DIR=${1:-./}
find $DIR -type f -print0 | xargs -0 touch
find $DIR -type f -print0 | sort -R -z| xargs -0 mplayer -xy .75
