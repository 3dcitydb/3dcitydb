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
-- 2.0.0     2014-07-30   complete revision for 3DCityDB V3      FKun
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
  FUNCTION table_content(table_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN NUMBER;
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
    reportDate DATE;
    owner_name VARCHAR2(20);
  BEGIN
    SELECT SYSDATE INTO reportDate FROM DUAL;  
    report_header.extend; report_header(report_header.count) := ('Database Report on 3D City Model - Report date: ' || TO_CHAR(reportDate, 'DD.MM.YYYY HH24:MI:SS'));
    report_header.extend; report_header(report_header.count) := ('===================================================================');

    -- Determine current workspace
    ws := DBMS_WM.GetWorkspace;
    report_header.extend; report_header(report_header.count) := ('Current workspace: ' || ws);
    report_header.extend; report_header(report_header.count) := '';  

    owner_name := upper(schema_name);

    EXECUTE IMMEDIATE 'SELECT CAST(COLLECT(tab.t) AS STRARRAY) FROM (
	                     SELECT CASE WHEN at.table_name LIKE ''%\_LT'' ESCAPE ''\'' THEN
                           (SELECT geodb_stat.table_label(view_name) || geodb_stat.table_content(view_name, :1) FROM all_views 
                              WHERE owner = :2 AND view_name = substr(at.table_name, 1, length(at.table_name)-3))
                         ELSE
                           (SELECT geodb_stat.table_label(table_name) || geodb_stat.table_content(table_name, :3) FROM all_tables
                              WHERE owner = :4 AND table_name = at.table_name) 
                         END AS t
                         FROM all_tables at
                           WHERE owner = :5
                           AND at.table_name NOT IN (''DATABASE_SRS'', ''OBJECTCLASS'', ''INDEX_TABLE'')
                           AND at.table_name NOT LIKE ''%\_AUX'' ESCAPE ''\''
                           AND at.table_name NOT LIKE ''%TMP\_%'' ESCAPE ''\''
                           AND at.table_name NOT LIKE ''%MDRT%''
                           AND at.table_name NOT LIKE ''%MDXT%''
                         ORDER BY at.table_name ASC
                       ) tab' INTO report USING owner_name, owner_name, owner_name, owner_name, owner_name;

    EXECUTE IMMEDIATE 'SELECT :1 MULTISET UNION :2 FROM dual' INTO report USING report_header, report;

    RETURN report;
  END;

  /*****************************************************************
  * table_content
  *
  * @param table_name name of table
  * @param schema_name name of schema
  * @RETURN INTEGER number of entries in table
  ******************************************************************/
  FUNCTION table_content(
    table_name VARCHAR2,
    schema_name VARCHAR2 := USER
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