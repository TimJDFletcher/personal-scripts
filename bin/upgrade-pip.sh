#!/bin/sh
pip list | awk '{print $1}' | xargs -n 1 pip install --upgrade
