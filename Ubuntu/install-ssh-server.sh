#!/bin/sh

key="ssh-dss AAAAB3NzaC1kc3MAAACBANnPy1THmYBBVhwWz0419JEL2jEtUsOYkBN0hpxgeJbU/vbv1qZQKb5I8vtSV1ebeHBUr4AklN0KiRcA7o7N5uicD+V7CAdoqs6kFESF8i4o5ss4SOu+pTaGC+Ke9w9KQKubFO7PRmd5PA+Vd2XIjsHlMEeazPM/mnc/d+ZWzhftAAAAFQDyr28YOsaQ+OEDdb/pDIRuEguTOQAAAIBFTE0Ba2dveqfd2J7DJ2Nl36w8lYVX1OySmG272g/i3sOd6TD4MQ/x9zT2Nwf9n8yjeXIn2mtpbUCH2Hvwq1/Q52xDtQlkug8zPEusis4K+/gupLBEDDS69RujDfWNMM4trAlSMPmutnZZqOg5ikdoTZD6ZSPFwyrfmpkTwRQhmQAAAIEAnqLT7YrYSdGcEmpa4RPbmF4DWwSqP6ur+1oTiKydDWA0J/j23vx6a49ws0lL0GO+ztEcsNbGJ1VvrPfvTGS35qxR2MIjOD+f2MAc0ETUxUd/zRIwwQsW4ZlNb6v/0tO7BHdL/b7+Yfr0RXr6Yg5ATbbMqwStD8k3EiCiyiVlwkw="

sudo aptitude update
sudo aptitude install openssh-server

mkdir $HOME/.ssh/

echo $key > $HOME/.ssh/authorized_keys

ip addr | grep inet | awk '{print $NF" "$2}'

