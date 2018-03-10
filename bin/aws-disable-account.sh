#!/bin/bash
AWS_PROFILE=$1

# Disable user login profile (AWS console access)
aws iam delete-login-profile --user-name=$2

# Collect a list of user keys
keys=$(aws iam list-access-keys --user-name $2| jq --raw-output '.AccessKeyMetadata[].AccessKeyId')

# Disable all users keys 
for key in $keys ; do
    echo disabling key $key
    aws iam update-access-key --access-key-id $key --status Inactive --user-name $2
done
