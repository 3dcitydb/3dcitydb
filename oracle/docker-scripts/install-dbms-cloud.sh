#!/usr/bin/env bash
# Install DBMS_CLOUD family packages and configure Select AI
# This script is called from 3dcitydb-initdb.sh when ENABLE_SELECT_AI=true
# ---------------------------------------------------------------------------

set -e

# Required env vars (inherited from 3dcitydb-initdb.sh)
: "${ORACLE_PWD:?ORACLE_PWD is required}"
: "${ORACLE_PDB:=FREEPDB1}"
: "${DB_USER:=citydb}"

ORACLE_HOME=${ORACLE_HOME:-/opt/oracle/product/26ai/dbhomeFree}
CLOUD_ADMIN_DIR="$ORACLE_HOME/rdbms/admin"
CATCON_PL="$CLOUD_ADMIN_DIR/catcon.pl"

SSL_WALLET_DIR="${SSL_WALLET_DIR:-/opt/oracle/wallet}"
SSL_WALLET_PWD="${SSL_WALLET_PWD:-WalletPass123}"
CLOUD_OWNER="${CLOUD_OWNER:-C##CLOUD\$SERVICE}"
CUSTOM_SQL_DIR="${CUSTOM_SQL_DIR:-/opt/oracle/3dcitydb-custom}"

DBMS_CLOUD_CERTS_URL="${DBMS_CLOUD_CERTS_URL:-https://objectstorage.us-phoenix-1.oraclecloud.com/p/KB63IAuDCGhz_azOVQ07Qa_mxL3bGrFh1dtsltreRJPbmb-VwsH2aQ4Pur2ADBMA/n/adwcdemo/b/CERTS/o/dbc_certs.tar}"

# --- Step 1: Create C##CLOUD$SERVICE schema (catclouduser.sql) ---------------
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

# --- Step 3: SSL wallet / cert config ----------------------------------------
echo
echo "Ensuring SSL wallet exists at $SSL_WALLET_DIR ..."

mkdir -p "$SSL_WALLET_DIR"

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

# --- Step 4: SYS setup (ACLs, roles, privileges, PDB grants) ----------------
echo
echo "[SelectAI][SYS] Running SYS setup (ACLs, roles, privileges) ..."

sqlplus -S -L / as sysdba <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

ALTER SESSION SET CONTAINER = CDB\$ROOT;

DEFINE SSL_WALLET_DIR='${SSL_WALLET_DIR}'
DEFINE CLOUD_OWNER='${CLOUD_OWNER}'
DEFINE PDB_NAME='${ORACLE_PDB}'
DEFINE DB_USER='${DB_USER}'

@${CUSTOM_SQL_DIR}/select-ai-sys-setup.sql
EXIT
SQL

echo "[SelectAI][SYS] SYS setup completed."

# --- Step 5: Verify outbound HTTPS connectivity (non-fatal) -----------------
echo
echo "Verifying outbound HTTPS connectivity ..."

if curl -fsSL --max-time 10 https://generativelanguage.googleapis.com >/dev/null 2>&1; then
  echo "[SelectAI][VERIFY] HTTPS connectivity OK."
else
  echo "[SelectAI][VERIFY][WARN] Cannot reach https://generativelanguage.googleapis.com (ignored)."
fi

# --- Step 6: Property catalog view + annotations (as app user in PDB) --------
echo
echo "[SelectAI] Creating property catalog view and schema annotations ..."

sqlplus -S "$DB_USER"/"$ORACLE_PWD"@"$ORACLE_PDB" <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

@${CUSTOM_SQL_DIR}/select-ai-property-catalog.sql

EXIT
SQL

echo "[SelectAI] Property catalog and annotations created."

# --- Step 7: Create AI profile (must run as app user in PDB) -----------------
if [ -z "${GOOGLE_API_KEY}" ]; then
  echo
  echo "[SelectAI][WARN] GOOGLE_API_KEY is not set. Skipping AI profile creation."
  echo "You can create the profile manually later by running select-ai-create-profile.sql."
else
  echo
  echo "Creating Google credential and profile ..."

  sqlplus -S "$DB_USER"/"$ORACLE_PWD"@"$ORACLE_PDB" <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

DEFINE GOOGLE_API_KEY='${GOOGLE_API_KEY}'
DEFINE GOOGLE_MODEL='${GOOGLE_MODEL:-gemini-2.5-flash}'
DEFINE DB_USER='${DB_USER^^}'

@${CUSTOM_SQL_DIR}/select-ai-create-profile.sql

EXIT
SQL

  echo "AI profile created successfully."
fi

echo "Select AI setup completed."
