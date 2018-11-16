#!/bin/sh
ORIGDIR=$(pwd)
case $(uname -s) in
    Darwin)
        FINDCMD=gfind
        SOURCEDIR=$(greadlink -f ${1:-./})
        ;;
    Linux)
        FINDCMD=find
        SOURCEDIR=$(readlink -f ${1:-./})
        ;;
    *)
        echo Unknown OS $OS, exiting
        exit 1
        ;;
esac

for dir in $($FINDCMD $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .svn ); do
    echo $dir ; cd $dir/.. ; svn upgrade ; svn up
done

for dir in $($FINDCMD $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name CVS ); do
    echo $dir ; cd $dir/.. ; cvs up
done

for dir in $($FINDCMD $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .hg ); do
    echo $dir ; cd $dir/.. ; hg up
done

for dir in $($FINDCMD $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .bzr ); do
    echo $dir ; cd $dir/.. ; bzr up
done

for dir in $($FINDCMD $SOURCEDIR -mindepth 1 -maxdepth 3 -type d -name .git ); do
    echo $dir ; cd $dir/..  ; git fetch ; git gc
done

cd $ORIGDIR
