#!/bin/sh
tempfile=$(mktemp /tmp/optimize.sql.XXXXXX)
mysql -p -Dinformation_schema --skip-column-names \
-e 'SELECT concat("OPTIMIZE TABLE ", table_schema,".",table_name,";") \
FROM tables WHERE DATA_FREE ;' > $tempfile

mysql -p -Dinformation_schema --skip-column-names < $tempfile


rm $tempfile
