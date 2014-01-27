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
-- 2.0       2014-01-07   complete revision for 3DCityDB V3      FKun
-- 1.0       2013-02-22   PostGIS version                        CNag     
--                                                               FKun
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   table_content(schema_name VARCHAR, table_name VARCHAR) RETURNS INTEGER
*   table_contents(schema_name VARCHAR DEFAULT 'public') RETURNS TEXT[]
*   table_label(table_name VARCHAR) RETURNS TEXT
******************************************************************/

/*****************************************************************
* table_contents
*
* @param schema_name name of schema
* @RETURN TEXT[] database report as text array
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.table_contents(schema_name VARCHAR DEFAULT 'public') RETURNS TEXT[] AS $$
DECLARE
  report_header TEXT[] := '{}'; 
  report TEXT[] := '{}';
BEGIN
  report_header := array_append(report_header, 'Database Report on 3D City Model - Report date: ' || TO_CHAR(now()::timestamp, 'DD.MM.YYYY HH24:MI:SS'));
  report_header := array_append(report_header, '===================================================================');
  PERFORM array_append(report_header, '');

  EXECUTE 'SELECT array_agg(t) FROM 
             (SELECT geodb_pkg.table_label(tablename::varchar) || geodb_pkg.table_content(schemaname::varchar, tablename::varchar) AS t 
                FROM pg_tables WHERE schemaname = $1 
                AND tablename != ''spatial_ref_sys'' 
                AND tablename != ''database_srs'' 
                AND tablename NOT LIKE ''tmp_%''
                ORDER BY tablename ASC
              ) tab' INTO report USING schema_name;

  report := array_cat(report_header,report);
  
  RETURN report;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* table_content
*
* @param schema_name name of schema
* @param table_name name of table
* @RETURN INTEGER number of entries in table
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.table_content(
  schema_name VARCHAR, 
  table_name VARCHAR
  ) RETURNS INTEGER AS $$
DECLARE
  cnt INTEGER;  
BEGIN
  EXECUTE format('SELECT count(*) FROM %I.%I', schema_name, table_name) INTO cnt;
  RETURN cnt;
END;
$$
LANGUAGE plpgsql;


/*****************************************************************
* table_label
*
* @param table_name name of table
* @RETURN VARCHAR formatted string for database report
******************************************************************/
CREATE OR REPLACE FUNCTION geodb_pkg.table_label(table_name VARCHAR) 
  RETURNS TEXT AS $$
DECLARE
  label TEXT := '#';
BEGIN
  label := label || upper(table_name);

  CASE 
    WHEN length(table_name) < 7 THEN label := label || E'\t\t\t\t';
    WHEN length(table_name) > 6 AND length(table_name) < 15 THEN label := label || E'\t\t\t';
    WHEN length(table_name) > 14 AND length(table_name) < 23 THEN label := label || E'\t\t';
    WHEN length(table_name) > 22 THEN label := label || E'\t';
  ELSE
    -- do nothing
  END CASE;
  
  RETURN label;
END;
$$
LANGUAGE plpgsql;