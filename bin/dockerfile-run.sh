#!/bin/bash -e
REPO_URI=docker-registry.laterooms.io:5000
CONTAINER=$(basename $PWD)
VERSION=$(git rev-parse --short HEAD)

docker run --rm -it \
    ${REPO_URI}/${CONTAINER}:${VERSION} $*
