#!/bin/sh
pip freeze | xargs -n 1 pip install --upgrade
