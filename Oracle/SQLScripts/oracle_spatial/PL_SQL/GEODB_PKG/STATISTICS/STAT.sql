-- STAT.sql
--
-- Authors:     Felix Kunde <fkunde@virtualcitysystems.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2014  Chair of Geoinformatics,
--                             Technische Universität München, Germany
--                             http://www.gis.bv.tum.de
--
--              (c) 2007-2012  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Creates method for creating database statistics.
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                          | Author
-- 2.0       2014-01-09   complete revision for 3DCityDB V3      FKun
--                                                               CNag
--

/*****************************************************************
* PACKAGE geodb_stat
* 
* utility methods for creating database statistics
******************************************************************/
CREATE OR REPLACE PACKAGE geodb_stat
AS
  FUNCTION table_contents(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION table_content(schema_name VARCHAR, table_name VARCHAR) RETURN NUMBER;
  FUNCTION table_label(table_name VARCHAR2) RETURN VARCHAR2;
END geodb_stat;
/

CREATE OR REPLACE PACKAGE BODY geodb_stat
AS

  /*****************************************************************
  * table_contents
  *
  * @param schema_name name of schema
  * @RETURN TEXT[] database report as text array
  ******************************************************************/
  FUNCTION table_contents(schema_name VARCHAR2 := USER) RETURN STRARRAY
  IS
    report_header STRARRAY := STRARRAY();
    report STRARRAY := STRARRAY();
    ws VARCHAR2(30);
    cnt NUMBER;
    refreshDate DATE;
    reportDate DATE;
    pa_id PLANNING_ALTERNATIVE.ID%TYPE;
    pa_title PLANNING_ALTERNATIVE.TITLE%TYPE;
    owner_name VARCHAR2(20);
  BEGIN
    SELECT SYSDATE INTO reportDate FROM DUAL;  
    report_header.extend; report_header(report_header.count) := ('Database Report on 3D City Model - Report date: ' || TO_CHAR(reportDate, 'DD.MM.YYYY HH24:MI:SS'));
    report_header.extend; report_header(report_header.count) := ('===================================================================');
  
    -- Determine current workspace
    ws := DBMS_WM.GetWorkspace;
    report_header.extend; report_header(report_header.count) := ('Current workspace: ' || ws);
  
    IF ws != 'LIVE' THEN
      -- Get associated planning alternative
      SELECT id,title INTO pa_id,pa_title FROM PLANNING_ALTERNATIVE
      WHERE workspace_name=ws;
      report_header.extend; report_header(report_header.count) := (' (PlanningAlternative ID ' || pa_id ||': "' || pa_title || '")');

      -- Query date of last refresh
      SELECT createtime INTO refreshDate
      FROM all_workspace_savepoints
      WHERE savepoint='refreshed' AND workspace=ws;
      report_header.extend; report_header(report_header.count) := ('Last refresh from LIVE workspace: ' || TO_CHAR(refreshDate, 'DD.MM.YYYY HH24:MI:SS'));
    END IF;
    report_header.extend; report_header(report_header.count) := '';

    owner_name := upper(schema_name);

    EXECUTE IMMEDIATE 'SELECT CAST(COLLECT(tab.t) AS STRARRAY) FROM (
                         SELECT geodb_stat.table_label(table_name) || geodb_stat.table_content(owner, table_name) AS t
                           FROM all_tables WHERE owner = upper(:1) 
                           AND table_name != ''database_srs''
                           AND table_name NOT LIKE ''%MDRT%''
                           AND length(table_name) <= 26
                           ORDER BY table_name ASC
                         ) tab' INTO report USING owner_name;

    EXECUTE IMMEDIATE 'SELECT :1 MULTISET UNION :2 FROM dual' INTO report USING report_header, report;

    RETURN report;
  END;

  /*****************************************************************
  * table_content
  *
  * @param schema_name name of schema
  * @param table_name name of table
  * @RETURN INTEGER number of entries in table
  ******************************************************************/
  FUNCTION table_content(
    schema_name VARCHAR, 
    table_name VARCHAR
  ) RETURN NUMBER
  IS
    cnt NUMBER;  
  BEGIN
    EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || schema_name || '.' || table_name INTO cnt;
    RETURN cnt;
  END;

  /*****************************************************************
  * table_label
  *
  * @param table_name name of table
  * @RETURN VARCHAR formatted string for database report
  ******************************************************************/
  FUNCTION table_label(table_name VARCHAR2) RETURN VARCHAR2
  IS
    label VARCHAR2(100) := '#';
  BEGIN
    label := label || upper(table_name);

    CASE 
      WHEN length(table_name) < 7 THEN label := label || '\t\t\t\t';
      WHEN length(table_name) > 6 AND length(table_name) < 15 THEN label := label || '\t\t\t';
      WHEN length(table_name) > 14 AND length(table_name) < 23 THEN label := label || '\t\t';
      WHEN length(table_name) > 22 THEN label := label || '\t';
    ELSE
      -- do nothing
      NULL;
    END CASE;

    RETURN label;
  END;

END geodb_stat;
/