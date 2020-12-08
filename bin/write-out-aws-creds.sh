#!/bin/bash
set -e -u -o pipefail
export AWS_PROFILE=cloud-engine-eks
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set aws_session_token ${AWS_SESSION_TOKEN}
