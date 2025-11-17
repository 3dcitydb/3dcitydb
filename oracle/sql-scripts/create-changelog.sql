SET SERVEROUTPUT ON
SET FEEDBACK ON
SET VERIFY OFF
SET SHOWMODE OFF
WHENEVER SQLERROR EXIT

PROMPT
PROMPT Setting up changelog extension ...
@@changelog/changelog-table.sql
@@changelog/feature-trigger.sql
@@changelog/spatial-objects.sql

COMMIT;

PROMPT Changelog extension successfully created.
QUIT;
/