#!/bin/bash
UPSS="10.0.6.29 10.0.6.30"
OIDS=".1.3.6.1.4.1.318.1.1.1.1.1.1.0
.1.3.6.1.4.1.318.1.1.1.2.2.3.0
.1.3.6.1.4.1.318.1.1.1.2.2.1.0"
for UPS in $UPSS ; do
	echo $UPS
	for OID in $OIDS ; do
		snmpwalk -v 2c -c public $UPS $OID 
	done
done

