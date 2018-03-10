#!/bin/sh
DB_LOCATION="$HOME/.config/f-spot/photos.db"
backuppath=/photos/f-spot/backups/
date=$(date +%Y%m%d%H%M)

echo ".dump" | sqlite3 $DB_LOCATION > $backuppath/f-spot-$date.sqlite.backup
xz $backuppath/f-spot-$date.sqlite.backup
echo "PRAGMA integrity_check;" | sqlite3 $DB_LOCATION
echo "VACUUM;" | sqlite3 $DB_LOCATION
