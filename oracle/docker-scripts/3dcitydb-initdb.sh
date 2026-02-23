#!/usr/bin/env bash
# 3DCityDB setup --------------------------------------------------------------

# Exit on error
set -e

# Set 3DCityDB version --------------------------------------------------------
if [ -z $CITYDB_VERSION ]; then
  # CITYDB_VERSION unset, read version from the version.txt file
  CITYDB_VERSION=$(< version.txt)
fi

# ORACLE_PWD ------------------------------------------------------------------
if [ -z $ORACLE_PWD ]; then
  echo
  echo "ORACLE_PWD is not set. No 3DCityDB instance will be created."
  echo
  exit
fi

# SRID ------------------------------------------------------------------------
regex_numeric='^[0-9]+$'
if [ -z ${SRID+x} ]; then
  # No SRID set -> give instructions on how to create a DB and do nothing
  echo
  echo "SRID is not set. No 3DCityDB instance will be created."
  echo
  exit
else
  # SRID given, check if valid
  if [[ ! $SRID =~ $regex_numeric ]] || [ $SRID -le 0 ]; then
        echo
        echo 'Illegal input. Enter a positive integer for the SRID.'
  fi
fi

# SRS_NAME --------------------------------------------------------------------
if [ -z ${SRS_NAME+x} ]; then
  # SRS_NAME unset, set default SRS_NAME using HEIGHT_EPSG if set
  # HEIGHT EPSG ---------------------------------------------------------------
  if [ -z ${HEIGHT_EPSG+x} ]; then
    # No HEIGHT_EPSG given
    SRS_NAME="urn:ogc:def:crs:EPSG::$SRID"
  else
    if [ $HEIGHT_EPSG -gt 0 ]; then
      SRS_NAME="urn:ogc:def:crs,crs:EPSG::$SRID,crs:EPSG::$HEIGHT_EPSG"
    else
      SRS_NAME="urn:ogc:def:crs:EPSG::$SRID"
    fi
  fi
else
  if [ ! -z ${HEIGHT_EPSG+x} ]; then
    # SRS_NAME is set, HEIGHT_EPSG is ignored
    echo
    echo "WARNING: SRS_NAME is set. HEIGHT_EPSG will be ignored."
  fi
fi

# CHANGELOG -------------------------------------------------------------------
if [ -z ${CHANGELOG+x} ]; then
  CHANGELOG="no"
fi

# ORACLE_PDB ------------------------------------------------------------------
if [ -z ${ORACLE_PDB+x} ]; then
  ORACLE_PDB="FREEPDB1"
fi

# DB_USER ---------------------------------------------------------------------
if [ -z ${DB_USER+x} ]; then
  DB_USER="citydb"
fi

# Read Oracle version ---------------------------------------------------------
ORACLE_VERSION=$(sqlplus -S -L system/"$ORACLE_PWD"@"$ORACLE_PDB" <<-EOF
  SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
  SELECT banner FROM v\$version;
EOF
)

# Create user -----------------------------------------------------------------
echo
echo "Creating user '$DB_USER' ..."
sqlplus -S -L system/"$ORACLE_PWD"@"$ORACLE_PDB" <<-EOF > /dev/null
  CREATE USER IF NOT EXISTS $DB_USER IDENTIFIED BY $ORACLE_PWD;
  ALTER USER $DB_USER QUOTA UNLIMITED ON USERS;
  GRANT CONNECT, RESOURCE to $DB_USER;
  GRANT CREATE SESSION TO $DB_USER;
  GRANT DB_DEVELOPER_ROLE TO $DB_USER;
EOF
echo "Creating user '$DB_USER' done."

# Setup 3DCityDB schema -------------------------------------------------------
echo
echo "Setting up 3DCityDB database schema for user '$DB_USER' ..."
sqlplus -S -L "$DB_USER"/"$ORACLE_PWD"@"$ORACLE_PDB" @create-db.sql \
  "${SRID}" "${SRS_NAME}" "${CHANGELOG}" > /dev/null
echo "Setting up 3DCityDB database schema for user '$DB_USER' done."


# Install DBMS_CLOUD family packages
# ---------------- DBMS_CLOUD + Select AI ------------------------------------

# --- Step 1: Create C##CLOUD$SERVICE schema (catclouduser.sql) ---------------

# setup directory variables
ORACLE_HOME=${ORACLE_HOME:-/opt/oracle/product/26ai/dbhomeFree}
CLOUD_ADMIN_DIR="$ORACLE_HOME/rdbms/admin"
CATCLOUDUSER_SQL="$CLOUD_ADMIN_DIR/catclouduser.sql"
DBMS_CLOUD_INSTALL_SQL="$CLOUD_ADMIN_DIR/dbms_cloud_install.sql"
CATCON_PL="$CLOUD_ADMIN_DIR/catcon.pl"

# ensure we always reference the script directory
SCRIPT_DIR="/opt/oracle/scripts/startup"

echo
echo "[DBMS_CLOUD] Running catclouduser.sql (create C##CLOUD\$SERVICE) ..."
"$ORACLE_HOME/perl/bin/perl" "$CATCON_PL" \
  -u "sys/${ORACLE_PWD} as sysdba" \
  --force_pdb_mode "READ WRITE" \
  -b catclouduser \
  -d "$CLOUD_ADMIN_DIR" \
  -l /tmp \
  catclouduser.sql

# --- Step 2: Install DBMS_CLOUD package family (dbms_cloud_install.sql) ------
echo
echo "[DBMS_CLOUD] Running dbms_cloud_install.sql (install DBMS_CLOUD family) ..."
"$ORACLE_HOME/perl/bin/perl" "$CATCON_PL" \
  -u "sys/${ORACLE_PWD} as sysdba" \
  --force_pdb_mode "READ WRITE" \
  -b dbms_cloud_install \
  -d "$CLOUD_ADMIN_DIR" \
  -l /tmp \
  dbms_cloud_install.sql

echo "[DBMS_CLOUD] catcon.pl completed."

# Wallet / cert config
SSL_WALLET_DIR="${SSL_WALLET_DIR:-/opt/oracle/wallet}"
SSL_WALLET_PWD="${SSL_WALLET_PWD:-WalletPass123}"

# Where to fetch Oracle's demo cert bundle
DBMS_CLOUD_CERTS_URL="${DBMS_CLOUD_CERTS_URL:-https://objectstorage.us-phoenix-1.oraclecloud.com/p/KB63IAuDCGhz_azOVQ07Qa_mxL3bGrFh1dtsltreRJPbmb-VwsH2aQ4Pur2ADBMA/n/adwcdemo/b/CERTS/o/dbc_certs.tar}"

# DBMS_CLOUD internal owner
CLOUD_OWNER="${CLOUD_OWNER:-C##CLOUD\\$SERVICE}"

echo
echo "Ensuring SSL wallet exists at $SSL_WALLET_DIR ..."

mkdir -p "$SSL_WALLET_DIR"

# Create wallet if missing
if [ ! -f "$SSL_WALLET_DIR/ewallet.p12" ] && [ ! -f "$SSL_WALLET_DIR/cwallet.sso" ]; then
  ( cd "$SSL_WALLET_DIR" && orapki wallet create -wallet . -pwd "$SSL_WALLET_PWD" -auto_login )
  fi

  # Download + unpack cert bundle (idempotent)
  CERT_TMP="/tmp/dbc_certs"
  mkdir -p "$CERT_TMP"

  if [ ! -f "$CERT_TMP/.downloaded" ]; then
    echo "Downloading DBMS_CLOUD certificates bundle ..."
      if command -v curl >/dev/null 2>&1; then
          curl -fsSL "$DBMS_CLOUD_CERTS_URL" -o /tmp/dbc_certs.tar
            elif command -v wget >/dev/null 2>&1; then
                wget -qO /tmp/dbc_certs.tar "$DBMS_CLOUD_CERTS_URL"
                  else
                      echo "Neither curl nor wget is available; cannot download certificates." >&2
                          exit 1
                            fi
                              tar -xf /tmp/dbc_certs.tar -C "$CERT_TMP"
                                touch "$CERT_TMP/.downloaded"
                                fi

                                # Import certs (ignore duplicates)
                                echo "Importing trusted certificates into wallet ..."
                                shopt -s nullglob
                                for cert in "$CERT_TMP"/*.{cer,crt,pem} "$CERT_TMP"/*.der; do
                                  orapki wallet add -wallet "$SSL_WALLET_DIR" -trusted_cert -cert "$cert" -pwd "$SSL_WALLET_PWD" >/dev/null 2>&1 || true
                                  done
                                  shopt -u nullglob

                                  echo "Wallet ready."


# --- Step: Run Select AI SYS setup (network ACL + wallet ACE) ---------------
echo
echo "[SelectAI][SYS] Applying network ACL + wallet ACEs ..."

CUSTOM_SQL_DIR="${CUSTOM_SQL_DIR:-/opt/oracle/3dcitydb-custom}"

sqlplus -S -L / as sysdba <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

-- Ensure we are in CDB$ROOT (escape $ to avoid shell expansion)
ALTER SESSION SET CONTAINER = CDB\$ROOT;

DEFINE PDB_NAME='${ORACLE_PDB}'
DEFINE DB_USER='${DB_USER}'
DEFINE SSL_WALLET_DIR='${SSL_WALLET_DIR}'
DEFINE CLOUD_OWNER='${CLOUD_OWNER}'

@${CUSTOM_SQL_DIR}/selectai_sys_setup.sql
EXIT
SQL

# --- Step: Verify DBMS_CLOUD outbound HTTPS (non-fatal) ----------------------
echo
echo "Verifying DBMS_CLOUD HTTPS connectivity"

CUSTOM_SQL_DIR="${CUSTOM_SQL_DIR:-/opt/oracle/3dcitydb-custom}"
VERIFY_SQL="${CUSTOM_SQL_DIR}/selectai_verify_dbms_cloud.sql"

if [ ! -f "$VERIFY_SQL" ]; then
  echo "[SelectAI][VERIFY][WARN] Verification SQL not found: $VERIFY_SQL"
else
  sqlplus -S / as sysdba <<SQL || echo "[SelectAI][VERIFY][WARN] Verification failed (ignored)"
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK ON
SET ECHO ON

-- Switch to CDB$ROOT (escape $ to avoid bash expansion)
ALTER SESSION SET CONTAINER = CDB\$ROOT;

@${VERIFY_SQL}

BEGIN
  C##CLOUD\$SERVICE.GET_PAGE('https://www.oracle.com');
END;
/

EXIT
SQL
fi

echo "Verifying DBMS_CLOUD HTTPS connectivity step completed."

# --- Granting Privileges to User or Role
sqlplus -S / as sysdba <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

ALTER SESSION SET CONTAINER = CDB\$ROOT;

@/opt/oracle/3dcitydb-custom/selectai_grantprivileges_locRol.sql

EXIT
SQL

# --- Configuring ACEs for User or Role
sqlplus -S / as sysdba <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

ALTER SESSION SET CONTAINER = CDB\$ROOT;

@/opt/oracle/3dcitydb-custom/selectai_confACE_urRol.sql

EXIT
SQL

echo
echo "Granting INHERIT PRIVILEGES between CITYDB and C##CLOUD\$SERVICE ..."

# --- Grant Ingerit Privileges on user SYS to C##CLOUD\$SERVICE
#sqlplus -S / as sysdba <<SQL
#WHENEVER SQLERROR EXIT SQL.SQLCODE;
#ALTER SESSION SET CONTAINER = CDB\$ROOT;
#GRANT INHERIT PRIVILEGES ON USER SYS TO C##CLOUD\$SERVICE;
#EXIT
#SQL

# --- Grant Ingerit Privileges on user CITYDB to C##CLOUD\$SERVICE
#sqlplus -S / as sysdba <<SQL
#WHENEVER SQLERROR EXIT SQL.SQLCODE;
#ALTER SESSION SET CONTAINER = ${ORACLE_PDB};
#GRANT INHERIT PRIVILEGES ON USER C##CLOUD\$SERVICE TO CITYDB;
#GRANT INHERIT PRIVILEGES ON USER CITYDB TO C##CLOUD\$SERVICE;
#EXIT
#SQL

# --- Grant Network ACL for OpenAI endpoint
sqlplus -S / as sysdba <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;
ALTER SESSION SET CONTAINER = ${ORACLE_PDB};
@/opt/oracle/3dcitydb-custom/selectai_citydb_setup.sql
EXIT
SQL
echo "Grant is successfully"

# --- Creating AI profile (must run as CITYDB in FREEPDB1)
echo
echo "Creating OpenAI credential and profile ..."

sqlplus -S citydb/"$ORACLE_PWD"@"$ORACLE_PDB" <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

DEFINE OPENAI_API_KEY='${OPENAI_API_KEY}'

@/opt/oracle/3dcitydb-custom/selectai_setup.sql

EXIT
SQL

echo "AI setup completed successfully."


# Echo info -------------------------------------------------------------------
cat <<EOF


###############################################################################
#  _______   ___ _ _        ___  ___
# |__ /   \ / __(_) |_ _  _|   \| _ )
#  |_ \ |) | (__| |  _| || | |) | _ \\
# |___/___/ \___|_|\__|\_, |___/|___/
#                      |__/
#
# 3DCityDB Docker Oracle
#
# Oracle ----------------------------------------------------------------------
#   Oracle version      $ORACLE_VERSION
#
# 3DCityDB --------------------------------------------------------------------
#   3DCityDB version    $CITYDB_VERSION
#   ORACLE_PDB          $ORACLE_PDB
#   DB_USER             $DB_USER
#   SRID                $SRID
#   SRS_NAME            $SRS_NAME
#   HEIGHT_EPSG         $HEIGHT_EPSG
#   CHANGELOG enabled   $CHANGELOG
#
#   https://github.com/3dcitydb
#
# Maintainer ------------------------------------------------------------------
#   Karin Patenge
#   Oracle Global Services Deutschland GmbH
#   karin.patenge(at)oracle.com
#
################################################################################

EOF
