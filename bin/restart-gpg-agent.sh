#!/bin/sh
pkill -9 pinentry-mac
pkill -9 gpg-agent
pkill -9 scdaemon
pkill -9 dirmngr
pkill -9 gnupg-pkcs11-scd
sleep 1
#eval $($(brew --prefix gnupg)/bin/gpg-agent --daemon)
eval $(/usr/local/MacGPG2/bin/gpg-agent --daemon)
