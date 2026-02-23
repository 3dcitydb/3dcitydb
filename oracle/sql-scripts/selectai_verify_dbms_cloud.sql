-- selectai_verify_dbms_cloud.sql
-- Run as SYS (sqlplus / as sysdba) after DBMS_CLOUD + wallet setup

SET SERVEROUTPUT ON

ALTER SESSION SET CURRENT_SCHEMA = C##CLOUD$SERVICE;

CREATE OR REPLACE PROCEDURE GET_PAGE (url IN VARCHAR2) AS
  request_context  UTL_HTTP.REQUEST_CONTEXT_KEY;
  req              UTL_HTTP.REQ;
  resp             UTL_HTTP.RESP;
  data             VARCHAR2(32767) := NULL;
  err_num          NUMBER := 0;
  err_msg          VARCHAR2(4000) := NULL;
BEGIN
  request_context := UTL_HTTP.CREATE_REQUEST_CONTEXT(
                       wallet_path     => 'file:/opt/oracle/wallet',
                       wallet_password => 'WalletPass123');

  -- If you use a proxy, set it here:
  -- UTL_HTTP.SET_PROXY('http://myproxyhost.mydomain:99', NULL);

  req  := UTL_HTTP.BEGIN_REQUEST(url => url, request_context => request_context);
  resp := UTL_HTTP.GET_RESPONSE(req);

  DBMS_OUTPUT.PUT_LINE('valid response');
  UTL_HTTP.END_RESPONSE(resp);

EXCEPTION
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 3800);
    DBMS_OUTPUT.PUT_LINE('possibly raised PLSQL/SQL error: ' || err_num || ' - ' || err_msg);
    BEGIN
      UTL_HTTP.END_RESPONSE(resp);
    EXCEPTION WHEN OTHERS THEN NULL; END;
    data := UTL_HTTP.GET_DETAILED_SQLERRM;
    IF data IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('possibly raised HTML error: ' || data);
    END IF;
END;
/
