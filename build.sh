#!/usr/bin/env bash

CUR_DIR=$(readlink -e $(dirname "$0"))
IMAGE_REPOSITORY=harbor.hsrc.dev
PROJECT_NAME=bigdata

FULL_IMAGE_TAG=$IMAGE_REPOSITORY/$PROJECT_NAME/$IMAGE_TAG

pushd "${CUR_DIR}"

echo ">>> creating model tgz file"
tar -v -czf your_model_package.tgz model-resource system
echo ">>> model tgz file created"

echo ">>> building image with tag: '$FULL_IMAGE_TAG'"
docker build -t $FULL_IMAGE_TAG \
--build-arg MODEL_TYPE=$MODEL_TYPE \
--build-arg MODEL_CODE=$MODEL_CODE \
--build-arg MODEL_VERSION=$MODEL_VERSION \
--build-arg MODEL_INSTANCE=$MODEL_INSTANCE \
-f $CUR_DIR/Dockerfile --no-cache $CUR_DIR
echo ">>> building image '$FULL_IMAGE_TAG' finished"

echo ">>> pushing image '$FULL_IMAGE_TAG'"
docker push $FULL_IMAGE_TAG
echo ">>> pushing image finished"

popd