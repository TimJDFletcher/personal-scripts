#!/bin/bash -e

if ! grep -q pam_tid.so /etc/pam.d/sudo ; then 
    sudo gsed -i -e '2iauth       sufficient     pam_tid.so\' /etc/pam.d/sudo
fi

sudo sysctl debug.lowpri_throttle_enabled=0
