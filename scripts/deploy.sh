#!/usr/bin/env bash
set -e

# login into Docker Hub
echo Docker Hub login...
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# push image
echo Pushing $IMAGE...
docker push $IMAGE

# tag and push if latest
if [ "$LATEST" == "true" ]; then
    echo Tagging latest with $IMAGE
    LATEST_IMAGE=${IMAGE/$VERSION/latest}
    docker tag $IMAGE $LATEST_IMAGE

    echo Pushing latest image...
    docker push $LATEST_IMAGE
fi
