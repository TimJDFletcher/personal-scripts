#!/bin/sh
machine=$(/usr/bin/hostname.exe)

usercheck(){
/usr/local/bin/psloggedon.exe -accepteula -l -x 2>&1 | grep -v cyg_server | grep -i $machine
}

if usercheck ; then
	echo Local user logged in, not shutting down
	exit 0
else
	echo No local user logged in, shutting down
	shutdown /s /t 60
fi
