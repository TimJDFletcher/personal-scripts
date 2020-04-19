#!/bin/bash
TIMESTAMP=$(date +%s)
set -e -u -o pipefail

# Taken from https://www.reddit.com/r/macsysadmin/comments/d6v409/tcc_microphone_access_for_skype_for_business/
# If you get this error message: “Error: unable to open database "/…./Library/Application Support/com.apple.TCC/TCC.db": unable to open database file”
# change your security settings and allow “terminal” to have full access to your drive (via system setting of macOS)

sqlite3 $HOME/Library/Application\ Support/com.apple.TCC/TCC.db \
  "insert or replace into access VALUES('kTCCServiceCamera','com.microsoft.SkypeForBusiness',0,1,1,NULL,NULL,NULL,'UNUSED',NULL,0,$TIMESTAMP) ;"

sqlite3 $HOME/Library/Application\ Support/com.apple.TCC/TCC.db \
  "insert or replace into access VALUES('kTCCServiceMicrophone','com.microsoft.SkypeForBusiness',0,1,1,NULL,NULL,NULL,'UNUSED',NULL,0,$TIMESTAMP) ;"

sqlite3 $HOME/Library/Application\ Support/com.apple.TCC/TCC.db \
  "insert or replace into access VALUES('kTCCServiceScreenRecording','com.microsoft.SkypeForBusiness',0,1,1,NULL,NULL,NULL,'UNUSED',NULL,0,$TIMESTAMP) ;"