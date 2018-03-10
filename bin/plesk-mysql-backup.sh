#!/bin/sh
target=/var/spool/backups/mysql
date=$(date +%Y%m%d%H%M)
maxage=14
user=admin
mysqldump_options="--no-create-info --skip-extended-insert --skip-comments --no-create-db"
password=$(cat /etc/psa/.psa.shadow)
dbs="$(echo 'show databases;' | mysql -u$user -p$password | egrep -v ^Database$\|^information_schema$\|^performance_schema$ )"

mkdir -p $target
for database in $dbs ; do
	mysqldump -u$user -p$password $database | gzip -c -9 > $target/$database-$date.gz 
done

find $target -type f -mtime +$maxage -print0 | xargs --no-run-if-empty -0 rm
