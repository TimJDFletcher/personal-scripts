#!/bin/sh
tests="12-randread-threads 12-randrw-threads 8-threads-mixed 8-thread-streamingread 8-thread-streamingwrite"
options=$(find /benchmark/ -mindepth 1 -maxdepth 1 -type d -printf '%f ')
export SIZE=32G
export TIME=10m

for setting in $options ; do
        export DIRECTORY=/benchmark/$setting
        for test in $tests ; do
                fio fio-config/fio_config-$test.cfg -o results/$setting-$test.out
        done
done

