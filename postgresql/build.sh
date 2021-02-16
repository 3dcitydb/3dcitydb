#!/usr/bin/env bash

DOCKER_BUILDKIT=1 \
docker build \
  -t 3dcitydb/3dcitydb-pg:edge \
  --no-cache \
  ./postgresql
