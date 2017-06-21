-- 3D City Database - The Open Source CityGML Database
-- http://www.3dcitydb.org/
-- 
-- Copyright 2013 - 2016
-- Chair of Geoinformatics
-- Technical University of Munich, Germany
-- https://www.gis.bgu.tum.de/
-- 
-- The 3D City Database is jointly developed with the following
-- cooperation partners:
-- 
-- virtualcitySYSTEMS GmbH, Berlin <http://www.virtualcitysystems.de/>
-- M.O.S.S. Computer Grafik Systeme GmbH, Taufkirchen <http://www.moss.de/>
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
--     
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

/*****************************************************************
* PACKAGE citydb_stat
* 
* utility methods for creating database statistics
******************************************************************/
CREATE OR REPLACE PACKAGE citydb_stat
AS
  FUNCTION table_contents(schema_name VARCHAR2 := USER) RETURN STRARRAY;
  FUNCTION table_content(table_name VARCHAR2, schema_name VARCHAR2 := USER) RETURN NUMBER;
END citydb_stat;
/

CREATE OR REPLACE PACKAGE BODY citydb_stat
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
                           (SELECT ''#'' || upper(table_name) ||
                              (CASE WHEN length(table_name) < 7 THEN ''\t\t\t\t''
                                    WHEN length(table_name) > 6 AND length(table_name) < 15 THEN ''\t\t\t''
                                    WHEN length(table_name) > 14 AND length(table_name) < 23 THEN ''\t\t''
                                    WHEN length(table_name) > 22 THEN ''\t'' 
                               END)
                            || citydb_stat.table_content(view_name, :1) FROM all_views 
                              WHERE owner = :2 AND view_name = substr(at.table_name, 1, length(at.table_name)-3))
                         ELSE
                           (SELECT ''#'' || upper(table_name) ||
                              (CASE WHEN length(table_name) < 7 THEN ''\t\t\t\t''
                                    WHEN length(table_name) > 6 AND length(table_name) < 15 THEN ''\t\t\t''
                                    WHEN length(table_name) > 14 AND length(table_name) < 23 THEN ''\t\t''
                                    WHEN length(table_name) > 22 THEN ''\t'' 
                               END)
                            || citydb_stat.table_content(table_name, :3) FROM all_tables
                              WHERE owner = :4 AND table_name = at.table_name) 
                         END AS t
                         FROM all_tables at
                           WHERE owner = :5
                           AND at.table_name NOT IN (''DATABASE_SRS'', ''OBJECTCLASS'', ''INDEX_TABLE'', ''ADE'', ''SCHEMA'', ''SCHEMA_TO_OBJECTCLASS'', ''SCHEMA_REFERENCING'')
                           AND at.table_name NOT LIKE ''%\_AUX'' ESCAPE ''\''
                           AND at.table_name NOT LIKE ''%TMP\_%'' ESCAPE ''\''
                           AND at.table_name NOT LIKE ''%MDRT%''
                           AND at.table_name NOT LIKE ''%MDXT%''
                           AND at.table_name NOT LIKE ''%MDNT%''
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

END citydb_stat;
/