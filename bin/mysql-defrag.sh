#!/bin/bash
password=ub81ez
# Get a list of all fragmented tables
ALL_TABLES="$( mysql --password=$password -e 'use information_schema; SELECT TABLE_SCHEMA,TABLE_NAME \
FROM TABLES WHERE TABLE_SCHEMA NOT IN ("information_schema","mysql")' | grep -v "^+" | sed "s,\t,.," )"

for fragment in $ALL_TABLES; do
   database="$( echo $fragment | cut -d. -f1 )"
   table="$( echo $fragment | cut -d. -f2 )"
   echo $database $table
   [ $fragment != "TABLE_SCHEMA.TABLE_NAME" ] && mysql --password=$password -e "USE $database;\
   OPTIMIZE TABLE $table;" > /dev/null 2>&1
done

