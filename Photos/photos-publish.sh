#!/bin/sh
find /photos/Published/ -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 exiftool '-FileName<CreateDate' -d %Y%m%d_%H%M%S%%-c.%%e
find /photos/Published/ -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 exiftool '-DateTimeOriginal>FileModifyDate'
rsync -avcPHS --exclude="iPod Photo Cache" --delete /photos/Published/ carbon:/archives/photos/published/
