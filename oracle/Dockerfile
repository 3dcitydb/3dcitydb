# 3DCityDB Oracle Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################

# Base image
ARG BASEIMAGE_TAG='19.3.0.0'
FROM container-registry.oracle.com/database/enterprise:${BASEIMAGE_TAG}

# Set 3DCityDB version
ARG CITYDB_VERSION='4.4.2'
ENV CITYDBVERSION=${CITYDB_VERSION}

# Copy SQL scripts
WORKDIR /3dcitydb
COPY SQLScripts .
COPY DockerScripts/3dcitydb-initdb.sh /docker-entrypoint-initdb.d/setup/

# Set labels
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="b.willenborg(at)tum.de"
LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
LABEL source.repo="https://github.com/3dcitydb/3dcitydb"
