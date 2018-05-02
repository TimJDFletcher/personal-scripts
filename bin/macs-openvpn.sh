#!/bin/bash
OVPN_VERSION=2.4.4-openssl-1.0.2o
APP_PATH="/Applications/Tunnelblick.app"
LIB_PATH="/Library/Application Support/Tunnelblick"
CONNECTION="Berlin DC - PKSC11"

sudo ${APP_PATH}/Contents/Resources/openvpn/openvpn-${OVPN_VERSION}/openvpn \
    --cd     "${LIB_PATH}/Users/${LOGNAME}/${CONNECTION}.tblk/Contents/Resources" \
    --config "${LIB_PATH}/Users/${LOGNAME}/${CONNECTION}.tblk/Contents/Resources/config.ovpn" \
    --up     "${APP_PATH}/Contents/Resources/client.up.tunnelblick.sh   -9 -d -f -m -w -ptADGNWradsgnw" \
    --down   "${APP_PATH}/Contents/Resources/client.down.tunnelblick.sh -9 -d -f -m -w -ptADGNWradsgnw" \
    --script-security 2
