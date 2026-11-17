SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SHOWMODE OFF
WHENEVER SQLERROR EXIT FAILURE
WHENEVER OSERROR EXIT FAILURE

@@changelog/changelog.sql

-- check for compilation errors
@@util/check-compilation.sql

COMMIT;

PROMPT Changelog extension successfully created.
QUIT;
/