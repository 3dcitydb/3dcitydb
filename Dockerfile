# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.org
#   GitHub              https://github.com/3dcitydb
###############################################################################

# Fetch & build stage #########################################################
# ARGS
ARG BASEIMAGE_TAG='18-3.6'
ARG BUILDER_IMAGE_TAG='21-jdk-jammy'

# Base image
FROM eclipse-temurin:${BUILDER_IMAGE_TAG} AS builder

# Copy source code
WORKDIR /build
COPY . /build

# Build
RUN chmod u+x ./gradlew && ./gradlew installDist

# Make init script executable
RUN chmod +x /build/build/install/3dcitydb/postgresql/docker-scripts/3dcitydb-initdb.sh

# Runtime stage ###############################################################
# Base image
FROM postgis/postgis:${BASEIMAGE_TAG} AS runtime

# Set 3DCityDB version
ARG CITYDB_VERSION
ENV CITYDB_VERSION=${CITYDB_VERSION}

# Copy SQL scripts
WORKDIR /3dcitydb
COPY --from=builder /build/build/install/3dcitydb/version.txt .
COPY --from=builder /build/build/install/3dcitydb/postgresql/sql-scripts .
COPY --from=builder /build/build/install/3dcitydb/postgresql/docker-scripts/3dcitydb-initdb.sh /docker-entrypoint-initdb.d/

# Set labels
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="bruno.willenborg(at)list-eco.de"
LABEL maintainer.organization="LIST Eco GmbH & Co. KG"
LABEL source.repo="https://github.com/3dcitydb/3dcitydb"
