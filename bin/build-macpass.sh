#!/bin/bash
if [ x$1 == x ] ; then
    branch=master
else
    branch=$1
fi

cd $HOME/source/git/MacPass
git fetch
git checkout $branch
git pull
git submodule sync
git submodule init
carthage bootstrap --platform Mac
killall MacPass
xcodebuild -scheme MacPass -target MacPass -configuration Release
