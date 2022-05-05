#!/usr/bin/env bash

# Docker PostGIS versions
arr=(
  "9.5-2.5"   "9.5-3.0"
  "9.6-2.5"   "9.6-3.0"  "9.6-3.1"  "9.6-3.2"
  "10-2.5"    "10-3.0"   "10-3.1"   "10-3.2"
  "11-2.5"    "11-3.0"   "11-3.1"   "11-3.2"
  "12-2.5"    "12-3.0"   "12-3.1"   "12-3.2"
              "13-3.0"   "13-3.1"   "13-3.2"
                         "14-3.1"   "14-3.2"
)

# Image variants
variant=("" "-alpine")

# CityDB version
citydb_version="4.3.0"

# Build and push all versions
for i in "${arr[@]}"
do
  for j in "${variant[@]}"
  do
    tag="${i}-$citydb_version$j"
    echo "Tag = $tag"
    docker pull postgis/postgis:$i$j
    docker build -t 3dcitydb/3dcitydb-pg:$tag ..\
      --build-arg BASEIMAGE_TAG=$i$j \
      --build-arg CITYDB_VERSION=$citydb_version
    docker push 3dcitydb/3dcitydb-pg:$tag
  done
done
