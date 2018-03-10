#!/bin/sh
echo "id,ip_internal,application,stack,tags.environment,cluster,service.clusterId,service.name,status,ukfastStatus"
for id in $(cat nr-ids.txt | sed -e s/^id//g) ; do 
    printf "$id,"
#    curl -s http://exocrine.cluster.elasticsearch.laterooms.io:9200/servers/_search?q=$id \
#        | jq -j -r '.hits.hits[]._source | [.ip_internal, .application, .stack, .tags.environment, .cluster, .service.clusterId, .service.name, .status, .ukfastStatus |tostring] | @csv'
    curl -s http://johnsonator.prod.laterooms.io/vm/$id \
        | jq -j -r '. | [.ip_internal, .application, .stack, .tags.environment, .cluster, .service.clusterId, .service.name, .status, .ukfastStatus |tostring] | @csv'
    echo
done 
