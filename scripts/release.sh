#!/bin/bash -e

STAGE=$1
DT=$(date "+%Y%m%d%H%M")

if [ -n "$STAGE" ]; then
  echo "Pushing tag: $STAGE-$DT"
  git tag -a "$STAGE-$DT" -m "$STAGE-$DT"
  git push --tags
else
  echo "Please provide a stage to release to."
fi
