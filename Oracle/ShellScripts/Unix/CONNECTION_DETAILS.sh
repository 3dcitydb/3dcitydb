#!/bin/bash
# Provide your database details here ------------------------------------------
export SQLPLUSBIN=path_to_sqlplus
export HOST=your_host_address
export PORT=1521
export SID=your_SID_or_database_name
export USERNAME=your_username
# -----------------------------------------------------------------------------

# Provide optional database details here --------------------------------------
# The scripts GRANT_RO_ACCESS and REVOKE_RO_ACCESS require SYSDBA privileges
export SYSDBA_USERNAME=
#------------------------------------------------------------------------------