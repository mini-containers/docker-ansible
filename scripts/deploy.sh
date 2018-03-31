#!/usr/bin/env bash
set -e

# login into Docker Hub
echo Docker Hub login...
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# push image
docker push $IMAGE

# tag and push if latest
if [ "$LATEST" == "true" ]; then
    LATEST_IMAGE=${IMAGE/$VERSION/latest}
    docker tag $LATEST_IMAGE $IMAGE
    docker push $LATEST_IMAGE
fi
