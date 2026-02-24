#!/bin/sh
set -e
TMP=$(mktemp)
read STDIN
echo "$STDIN" | qrencode -o "${TMP}.png"
open -W "${TMP}.png"
rm "$TMP" "${TMP}.png"
