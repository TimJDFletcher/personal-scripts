#!/bin/bash -x

# Generally based on ideas found at:
# http://www.garth.org/archives/2011,08,27,169,fix-time-machine-sparsebundle-nas-based-backup-errors.html
# 
# Reduced the ideas there down to their essentials.
# 1. Unlock the image.
# 2. Reset the saved failure in the backup metadata.
# 3. Verify/fix the filesystem.

# Take the arg. You did provide an arg, right?
IMAGE="$1"

if [ -z "$IMAGE" ]; then echo "usage: $0 image_path"; exit; fi

# Repair the stupid file lock.
chflags -v nouchg "$IMAGE"
chflags -v nouchg "$IMAGE/token"
chflags -v nouchg "$IMAGE/bands"

# Fix the plists
/usr/libexec/PlistBuddy -c "Delete :RecoveryBackupDeclinedDate" "$IMAGE/com.apple.TimeMachine.MachineID.plist"
/usr/libexec/PlistBuddy -c "Set :VerificationState 0" "$IMAGE/com.apple.TimeMachine.MachineID.plist"

# Start bailing on errors (can't set earlier due to PlistBuddy)
set -e

# Attach the image.
DEV=`hdiutil attach -nomount -noverify -noautofsck "$IMAGE" | awk '/HFS/ {print $1}'`
echo "$IMAGE -> $DEV"

# Fix the FS.
fsck_hfs -fy -c 8gb "$DEV"

# Detach it.
hdiutil detach "$DEV"
