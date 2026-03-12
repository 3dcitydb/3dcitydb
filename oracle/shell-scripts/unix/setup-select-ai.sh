#!/bin/bash
# Shell script to set up Oracle Select AI for the 3D City Database
# on Oracle Database 23ai or higher

# Get the current directory path of this script file
CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd "$CURRENT_DIR/../../sql-scripts"

# Read database connection details
if [ $# -ne 0 ]; then
  source "$1"
else
  if [ -f connection-details.sh ]; then
    source connection-details.sh
  else
    source "$CURRENT_DIR/connection-details.sh"
  fi
fi

# Set database client
if [ -z "$ORACLE_CLIENT" ]; then
  ORACLE_CLIENT="sqlplus"
elif [ -d "$ORACLE_CLIENT" ]; then
  ORACLE_CLIENT="$ORACLE_CLIENT/sqlplus"
fi

# Welcome message
echo ' _______   ___ _ _        ___  ___ '
echo '|__ /   \ / __(_) |_ _  _|   \| _ )'
echo ' |_ \ |) | (__| |  _| || | |) | _ \'
echo '|___/___/ \___|_|\__|\_, |___/|___/'
echo '                     |__/          '
echo
echo '3D City Database - Oracle Select AI Setup'
echo
echo '######################################################################################'
echo
echo 'This script sets up Oracle Select AI for the 3DCityDB. It requires:'
echo '  - Oracle Database 23ai or higher with DBMS_CLOUD_AI pre-installed'
echo '  - SYS (SYSDBA) access for network ACL and privilege configuration'
echo '  - An OpenAI API key for the AI profile'
echo
echo 'Documentation and help:'
echo '   3DCityDB website:    https://www.3dcitydb.org'
echo '   3DCityDB on GitHub:  https://github.com/3dcitydb'
echo
echo '######################################################################################'

# Prompt for SYS password -------------------------------------------------------
echo
read -sp "Please enter the SYS password: " SYS_PWD
echo
if [ -z "$SYS_PWD" ]; then
  echo "ERROR: SYS password is required."
  exit 1
fi

# Check DBMS_CLOUD_AI availability -----------------------------------------------
echo
echo "Checking DBMS_CLOUD_AI availability ..."
CLOUD_AI_CHECK=$("$ORACLE_CLIENT" -S -L "sys/${SYS_PWD}@${DB_HOST}:${DB_PORT}/${ORACLE_PDB} as sysdba" <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT COUNT(*) FROM dba_objects WHERE object_name = 'DBMS_CLOUD_AI' AND object_type = 'PACKAGE';
EXIT
EOF
)

# Trim whitespace
CLOUD_AI_CHECK=$(echo "$CLOUD_AI_CHECK" | tr -d '[:space:]')

if [ "$CLOUD_AI_CHECK" != "1" ]; then
  echo
  echo "ERROR: DBMS_CLOUD_AI is not available in this database."
  echo "Please install DBMS_CLOUD first. Refer to the Oracle documentation:"
  echo "  https://docs.oracle.com/en/database/oracle/oracle-database/23/arpls/DBMS_CLOUD.html"
  echo
  read -rsn1 -p 'Press ENTER to quit.'
  echo
  exit 1
fi

echo "DBMS_CLOUD_AI is available."

# Prompt for SSL wallet directory ------------------------------------------------
echo
read -p "Please enter the SSL wallet directory (default: /opt/oracle/wallet): " SSL_WALLET_DIR
SSL_WALLET_DIR=${SSL_WALLET_DIR:-/opt/oracle/wallet}

# Prompt for OpenAI API key ------------------------------------------------------
echo
read -sp "Please enter the OpenAI API key: " OPENAI_API_KEY
echo
if [ -z "$OPENAI_API_KEY" ]; then
  echo "ERROR: OpenAI API key is required."
  exit 1
fi

# Uppercase DB_USER for Oracle identifiers
DB_USER_UPPER=$(echo "$DB_USER" | tr '[:lower:]' '[:upper:]')

# --- Step 1: Run SYS setup (ACLs, roles, privileges, PDB grants) ---------------
echo
echo "Running SYS setup (ACLs, roles, privileges) ..."
echo "Connecting as SYS to \"${DB_HOST}:${DB_PORT}/${ORACLE_PDB}\" ..."

"$ORACLE_CLIENT" -S -L "sys/${SYS_PWD}@${DB_HOST}:${DB_PORT}/${ORACLE_PDB} as sysdba" <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

ALTER SESSION SET CONTAINER = CDB\$ROOT;

DEFINE SSL_WALLET_DIR='${SSL_WALLET_DIR}'
DEFINE CLOUD_OWNER='C##CLOUD\$SERVICE'
DEFINE PDB_NAME='${ORACLE_PDB}'
DEFINE DB_USER='${DB_USER_UPPER}'

@cloud-ai/select-ai-sys-setup.sql
EXIT
SQL

if [ $? -ne 0 ]; then
  echo
  echo "ERROR: SYS setup failed."
  read -rsn1 -p 'Press ENTER to quit.'
  echo
  exit 1
fi

echo "SYS setup completed successfully."

# --- Step 2: Property catalog view + annotations (as app user) -----------------
echo
echo "Creating property catalog view and schema annotations ..."
echo "Connecting to \"$DB_USER@$DB_HOST:$DB_PORT/$ORACLE_PDB\" ..."

"$ORACLE_CLIENT" -S -L "${DB_USER}@${DB_HOST}:${DB_PORT}/${ORACLE_PDB}" <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

@cloud-ai/select-ai-property-catalog.sql
EXIT
SQL

if [ $? -ne 0 ]; then
  echo
  echo "ERROR: Property catalog setup failed."
  read -rsn1 -p 'Press ENTER to quit.'
  echo
  exit 1
fi

echo "Property catalog and annotations created successfully."

# --- Step 3: Create AI profile (as app user) ------------------------------------
echo
echo "Creating OpenAI credential and AI profile ..."
echo "Connecting to \"$DB_USER@$DB_HOST:$DB_PORT/$ORACLE_PDB\" ..."

"$ORACLE_CLIENT" -S -L "${DB_USER}@${DB_HOST}:${DB_PORT}/${ORACLE_PDB}" <<SQL
WHENEVER OSERROR EXIT 9;
WHENEVER SQLERROR EXIT SQL.SQLCODE;

DEFINE OPENAI_API_KEY='${OPENAI_API_KEY}'
DEFINE DB_USER='${DB_USER_UPPER}'

@cloud-ai/select-ai-create-profile.sql
EXIT
SQL

if [ $? -ne 0 ]; then
  echo
  echo "ERROR: AI profile creation failed."
  read -rsn1 -p 'Press ENTER to quit.'
  echo
  exit 1
fi

echo
echo "Select AI setup completed successfully!"
echo "You can now use Select AI in your 3DCityDB instance."

echo
read -rsn1 -p 'Press ENTER to quit.'
echo
