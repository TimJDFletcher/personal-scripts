#!/bin/sh
export AWS_PROFILE=$1
aws iam generate-credential-report
sleep 5
aws iam get-credential-report --output text --query Content  | base64 -D > aws-credential-report-$1.csv
