#!/bin/sh
curl -s https://docker-registry.laterooms.io:5000/v2/_catalog | jq
