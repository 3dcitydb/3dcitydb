-- selectai_sys_setup.sql
-- Run as SYS (sqlplus / as sysdba)
-- Required SQL*Plus defines:
--   PDB_NAME       (e.g. FREEPDB1)
--   DB_USER        (e.g. CITYDB)
--   SSL_WALLET_DIR (e.g. /opt/oracle/wallet)
--   CLOUD_OWNER    (e.g. C##CLOUD$SERVICE)

WHENEVER SQLERROR EXIT SQL.SQLCODE;

BEGIN
  -- Allow HTTPS (port 443) to all hosts
  DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
    host        => '*',
    lower_port  => 443,
    upper_port  => 443,
    ace         => xs$ace_type(
      privilege_list => xs$name_list('http', 'http_proxy'),
      principal_name => UPPER('C##CLOUD$SERVICE'),
      principal_type => xs_acl.ptype_db
    )
  );

  -- Allow wallet usage
  DBMS_NETWORK_ACL_ADMIN.APPEND_WALLET_ACE(
    wallet_path => 'file:/opt/oracle/wallet',
    ace         => xs$ace_type(
      privilege_list => xs$name_list('use_client_certificates', 'use_passwords'),
      principal_name => UPPER('C##CLOUD$SERVICE'),
      principal_type => xs_acl.ptype_db
    )
  );
END;
/

