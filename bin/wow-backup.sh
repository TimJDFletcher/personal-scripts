#!/bin/bash

# --- CONFIGURATION ---
TIMESTAMP=$(date "+%Y-%m-%dT%H-%M-%S")

# Base path to WoW
# We specifically target _retail_ here. 
# If you play Classic, change _retail_ to _classic_
WOW_RETAIL="/Applications/World of Warcraft/_retail_"

TARGETDIR="$HOME/backups/wow-interface"
LOGDIR="$HOME/backups/logs"
CURRENT_LINK="$TARGETDIR/current"

# Ensure backup directories exist
mkdir -p "$TARGETDIR"
mkdir -p "$LOGDIR"

# --- SAFETY CHECK ---
# Check if valid WoW directories exist before trying to back up
if [ ! -d "$WOW_RETAIL/Interface" ] || [ ! -d "$WOW_RETAIL/WTF" ]; then
    echo "❌ Error: Could not find Interface or WTF folders at:"
    echo "   $WOW_RETAIL"
    echo "   Please verify your WoW installation path."
    exit 1
fi

# Check if WoW is running
if pgrep -f "World of Warcraft" > /dev/null; then
    echo "⚠️  Error: World of Warcraft is currently running."
    echo "   Backing up while playing can result in corrupted config files."
    exit 1
fi

# --- BACKUP ---
echo "Starting backup at $TIMESTAMP..."

# rsync command
# We list the folders explicitly as arguments. 
# This ensures rsync grabs exactly what we want without complex filter rules.
rsync -avh --delete \
    --link-dest="$CURRENT_LINK" \
    --exclude '.DS_Store' \
    "$WOW_RETAIL/Interface" \
    "$WOW_RETAIL/WTF" \
    "$WOW_RETAIL/Screenshots" \
    "$TARGETDIR/backup-$TIMESTAMP" > "$LOGDIR/$TIMESTAMP.log" 2>&1

# Check exit status
if [ "$?" = 0 ]; then
    echo "✅ Backup Successful."
    
    # Update the 'current' symlink
    ln -snf "$TARGETDIR/backup-$TIMESTAMP" "$CURRENT_LINK"
    
    # --- CLEANUP ---
    # Delete backups older than 30 days
    find "$TARGETDIR" -maxdepth 1 -type d -name "backup-*" -mtime +30 -exec rm -rf {} +
    echo "   Old backups cleaned up."
    
else
    echo "❌ Backup Failed! Check log at $LOGDIR/$TIMESTAMP.log"
    # Rename directory if failed so we don't accidentally link to it later
    mv "$TARGETDIR/backup-$TIMESTAMP" "$TARGETDIR/failed-$TIMESTAMP"
    exit 1
fi
