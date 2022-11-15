#!/usr/bin/env bash

CUR_DIR=$(readlink -e $(dirname "$0"))
export CUR_DIR

export IMAGE_TAG="offline:1"
export MODEL_TYPE="offline"
export MODEL_CODE=offline-test
export MODEL_VERSION=v1
export MODEL_INSTANCE="default"

# shellcheck disable=SC2086
$CUR_DIR/build.sh