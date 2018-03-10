#!/bin/bash -e
REPO_URI=docker-registry.laterooms.io:5000
CONTAINER=$(basename $PWD)
#VERSION=$(date +%Y%m%d%H%M%S)
VERSION=$(git rev-parse --short HEAD)

die () {
    echo >&2 "$@"
    exit 1
}

#  Pull repo
docker pull $REPO_URI/$CONTAINER:latest || echo building $VERSION

# Build image
docker build -t $CONTAINER:tmp .

# Tag with version (this will fail if version exists to prevent overwriting)
docker tag $CONTAINER:tmp $REPO_URI/$CONTAINER:$VERSION

# Tag as latest
docker tag $REPO_URI/$CONTAINER:$VERSION $REPO_URI/$CONTAINER:latest

# Push!
docker push $REPO_URI/$CONTAINER:$VERSION  || echo "There is already a version tagged $VERSION in the repository. Try again with a different tag"
docker push $REPO_URI/$CONTAINER:latest

echo Pushed to $REPO_URI/$CONTAINER:$VERSION
