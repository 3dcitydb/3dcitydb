#!/usr/bin/env bash

# Configure the repository to push to
repo="3dcitydb/3dcitydb-pg"

# Push images?
push=false

# CityDB version
citydb_version="4.4.0"

# Docker PostGIS versions
arr=(
  '9.5-2.5'  '9.5-3.0'
  '9.6-2.5'  '9.6-3.0'  '9.6-3.1'  '9.6-3.2'
  '10-2.5'   '10-3.0'   '10-3.1'   '10-3.2'
  '11-2.5'   '11-3.0'   '11-3.1'   '11-3.2'   '11-3.3'
  '12-2.5'   '12-3.0'   '12-3.1'   '12-3.2'   '12-3.3'
             '13-3.0'   '13-3.1'   '13-3.2'   '13-3.3'
                        '14-3.1'   '14-3.2'   '14-3.3'
                                   '15-3.2'   '15-3.3'
)

# Image variants
variant=("" "-alpine")

# Build and push all versions
for i in "${arr[@]}"
do
  for j in "${variant[@]}"
  do
    tag="${i}-$citydb_version$j"
    printf "\nTag = $tag\n"

    # Pull  latest base image
    docker pull postgis/postgis:$i$j

    # Build image
    docker build -t "$repo:$tag" ..\
      --build-arg BASEIMAGE_TAG=$i$j \
      --build-arg CITYDB_VERSION=$citydb_version

    # Push image
    if [[ "$push" = true ]]; then
      docker push "$repo:$tag"
    fi
  done
done
