# 3DCityDB Oracle Dockerfile #################################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb
###############################################################################

# Base image
FROM konnecteam/docker-oracle-12c:sequelize

ENV IMPORT_FROM_VOLUME='true'

# Copy SQL scripts
WORKDIR /3dcitydb
COPY SQLScripts .
COPY DockerScripts/3dcitydb-initdb.sh /docker-entrypoint-initdb.d/

# set labels
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="b.willenborg(at)tum.de"
LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
LABEL source.repo="https://github.com/3dcitydb/3dcitydb"
