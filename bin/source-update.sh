#!/bin/sh
SOURCEDIR=$(greadlink -f ${1:-./})
ORIGDIR=$(pwd)

for dir in $(find $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .svn ); do
    echo $dir ; cd $dir/.. ; svn upgrade
    echo $dir ; cd $dir/.. ; svn up
done

for dir in $(find $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name CVS ); do
    echo $dir ; cd $dir/.. ; cvs up
done

for dir in $(find $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .hg ); do
    echo $dir ; cd $dir ; hg up
done

for dir in $(find $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .bzr ); do
    echo $dir ; cd $dir ; bzr up
done

for dir in $(find $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .git ); do
    echo $dir ; cd $dir/..  ; git fetch ; git gc
done

cd $ORIGDIR
