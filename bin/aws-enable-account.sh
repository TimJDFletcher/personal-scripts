#!/bin/bash
AWS_PROFILE=$1

# Enable user login profile (AWS console access)
aws iam create-login-profile --user-name=$2

# Collect a list of user keys
keys=$(aws iam list-access-keys --user-name $2| jq --raw-output '.AccessKeyMetadata[].AccessKeyId')

# Disable all users keys 
for key in $keys ; do
    echo Enabling key $key
    aws iam update-access-key --access-key-id $key --status Active --user-name $2
done
