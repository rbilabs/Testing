#!/bin/bash -e

export AWS_XRAY_CONTEXT_MISSING=${AWS_XRAY_CONTEXT_MISSING:-LOG_ERROR}
export BRAND=${BRAND:-bk}
export NODE_ENV=${NODE_ENV:-dev}

DIR=$(dirname "$0")

"$DIR"/../node_modules/.bin/sls --config "$DIR"/../serverless.yml "$@"
