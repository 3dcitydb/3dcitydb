# Oracle Database Docker container

All Oracle Database scripts will be written for version 23ai. Container images of this version are currently only available as:

* Oracle Database Free
* Oracle Autonomous Database Free

## Setting up the container using Podman

```sh
podman run -d --name orcl23aifree \
-p 1521:1521 \
-e ORACLE_PWD=Welcome_1234# \
-e ENABLE_ARCHIVELOG=true \
-e ENABLE_FORCE_LOGGING=true \
-v [<host mount point>:]/opt/oracle/data \
container-registry.oracle.com/database/free:latest
```

## Setting up the container using Docker

```sh
docker run -d --name orcl23aifree \
-p 1521:1521 \
-e ORACLE_PWD=Welcome_1234# \
-e ENABLE_ARCHIVELOG=true \
-e ENABLE_FORCE_LOGGING=true \
-v [<host mount point>:]/opt/oracle/data \
container-registry.oracle.com/database/free:latest
```

## Connect to the container

### From outside the container

```sh
sqlplus citydb/Welcome_1234#@//localhost:1521/freepdb1
```
