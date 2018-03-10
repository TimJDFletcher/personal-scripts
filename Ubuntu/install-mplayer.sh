#!/bin/sh
export http_proxy=http://proxy:8080/

sudo -E wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list 
sudo -E apt-get --quiet update
sudo -E apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring 
sudo -E apt-get install mplayer vlc
sudo -E apt-get dist-upgrade
sudo -E apt-get autoclean

case $(uname -i) in
x86_64)
        sudo -E apt-get install w64codecs
;;
i386)
        sudo -E apt-get install w32codecs
;;
*)
        echo Unknown platform skipping codec install
;;
esac

