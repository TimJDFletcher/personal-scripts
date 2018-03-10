#!/bin/sh
export http_proxy=http://proxy:8080/
sudo -E aptitude update
sudo -E aptitude -y dist-upgrade
sudo -E aptitude autoclean
sudo -E apt-get autoremove
