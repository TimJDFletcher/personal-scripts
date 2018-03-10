#!/bin/bash -e
REPO_URI=docker-registry.laterooms.io:5000
CONTAINER=$(basename $PWD)
#VERSION=$(date +%Y%m%d%H%M%S)
VERSION=$(git rev-parse --short HEAD)
BUILDPATH=${1:-.}

die () {
    echo >&2 "$@"
    exit 1
}

#  Pull repo
docker pull $REPO_URI/$CONTAINER:latest || echo building $VERSION

# Build image
docker build -t $CONTAINER:tmp $BUILDPATH

# Tag with version (this will fail if version exists to prevent overwriting)
docker tag $CONTAINER:tmp $REPO_URI/$CONTAINER:$VERSION
docker tag $CONTAINER:tmp $REPO_URI/$CONTAINER:latest

echo Build tag $REPO_URI/$CONTAINER:$VERSION
