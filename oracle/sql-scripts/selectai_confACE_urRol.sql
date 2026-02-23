-- Run in CDB$ROOT
-- ============================================================
-- Safety check: must be executed in CDB$ROOT as SYS
-- ============================================================
DECLARE
  v_con_name VARCHAR2(128);
BEGIN
  v_con_name := SYS_CONTEXT('USERENV','CON_NAME');

  IF v_con_name <> 'CDB$ROOT' THEN
    RAISE_APPLICATION_ERROR(
      -20001,
      'This script must be run in CDB$ROOT as SYS. Current container = ' || v_con_name
    );
  END IF;
END;
/

@/opt/oracle/product/26ai/dbhomeFree/rdbms/admin/sqlsessstart.sql
-- Define target role
define cloudrole=C##CLOUD$SERVICE
-- CUSTOMER SPECIFIC SETUP
-- Set SSL Wallet directory (replace with your actual wallet path)
define sslwalletdir=/opt/oracle/wallet
-- Create New ACL / ACEs
BEGIN
    -- Allow all hosts for HTTPS (port 443)
    dbms_network_acl_admin.append_host_ace(
        host => '*',
        lower_port => 443,
        upper_port => 443,
        ace => xs$ace_type(
            privilege_list => xs$name_list('http', 'http_proxy'),
            principal_name => upper('&cloudrole'),
            principal_type => xs_acl.ptype_db));
    -- Allow wallet access
    dbms_network_acl_admin.append_wallet_ace(
        wallet_path => 'file:&sslwalletdir',
        ace => xs$ace_type(
            privilege_list => xs$name_list('use_client_certificates', 'use_passwords'),
            principal_name => upper('&cloudrole'),
            principal_type => xs_acl.ptype_db));
END;
/
@/opt/oracle/product/26ai/dbhomeFree/rdbms/admin/sqlsessend.sql
