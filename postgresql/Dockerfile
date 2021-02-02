# 3DCityDB PostGIS Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################

# Base image
ARG baseimage_tag='13-3.1'
FROM postgis/postgis:${baseimage_tag}

# Copy SQL scripts
WORKDIR /3dcitydb
COPY SQLScripts .
COPY dockerScripts/3dcitydb-initdb /usr/local/bin/

# Set permissions
RUN set -ex && \
  ln -vs /usr/local/bin/3dcitydb-initdb /docker-entrypoint-initdb.d/3dcitydb-initdb.sh && \
  chmod -v u+x /usr/local/bin/3dcitydb-initdb

# set labels
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="b.willenborg(at)tum.de"
LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
LABEL source.repo="https://github.com/3dcitydb/3dcitydb"
