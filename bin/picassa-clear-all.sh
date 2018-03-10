#!/bin/sh

# Tutorial: https://developers.google.com/gdata/articles/using_cURL
# Requires: curl, grep, sed

ACCOUNT="GOOGLE"
USERNAME="tim.fletcher@gmail.com"
PASSWORD=""
SERVICE="lh2"

# authenticate
AUTH_KEY=$(curl --silent "https://www.google.com/accounts/ClientLogin?accountType=$ACCOUNT&Email=$USERNAME&Passwd=$PASSWORD&service=$SERVICE" | grep 'Auth=' | sed -e 's|Auth=||g')
AUTH_HEADER="Authorization: GoogleLogin auth=$AUTH_KEY"

# get album list for deletion
RESPONSE=$(curl --silent --header "$AUTH_HEADER" "http://picasaweb.google.com/data/feed/api/user/default")
ALBUM_LIST_EDIT=$(echo "$RESPONSE" | sed -e 's|<link rel=.edit. type=.application/atom+xml. href=.|\n|g;s|./><link|\n|g' | grep '^http://')

# delete all albums
for ALBUM in $ALBUM_LIST_EDIT
do
    echo "$ALBUM" | sed 's|.*api|\.|g'
    curl --request DELETE --header "$AUTH_HEADER" "$ALBUM"
done
