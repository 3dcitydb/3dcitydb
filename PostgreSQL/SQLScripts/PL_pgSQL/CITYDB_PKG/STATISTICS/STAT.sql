-- STAT.sql
--
-- Authors:     Felix Kunde <felix-kunde@gmx.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
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
-- 2.0.0     2014-10-10   complete revision for 3DCityDB V3      FKun
-- 1.0.0     2013-02-22   PostGIS version                        CNag     
--                                                               FKun
--

/*****************************************************************
* CONTENT
*
* FUNCTIONS:
*   table_content(table_name TEXT, schema_name TEXT DEFAULT 'citydb') RETURNS INTEGER
*   table_contents(schema_name TEXT DEFAULT 'citydb') RETURNS TEXT[]
******************************************************************/

/*****************************************************************
* table_contents
*
* @param schema_name name of schema
* @RETURN TEXT[] database report as text array
******************************************************************/
CREATE OR REPLACE FUNCTION citydb_pkg.table_contents(schema_name TEXT DEFAULT 'citydb') RETURNS TEXT[] AS $$
DECLARE
  report_header TEXT[] := '{}'; 
  report TEXT[] := '{}';
BEGIN
  report_header := array_append(report_header, 'Database Report on 3D City Model - Report date: ' || TO_CHAR(now()::timestamp, 'DD.MM.YYYY HH24:MI:SS'));
  report_header := array_append(report_header, '===================================================================');
  PERFORM array_append(report_header, '');

  EXECUTE 'SELECT array_agg(t) FROM 
             (SELECT ''#'' || upper(table_name) ||
                (CASE WHEN length(table_name) < 7 THEN E''\t\t\t\t''
                      WHEN length(table_name) > 6 AND length(table_name) < 15 THEN E''\t\t\t''
                      WHEN length(table_name) > 14 AND length(table_name) < 23 THEN E''\t\t''
                      WHEN length(table_name) > 22 THEN E''\t''
                END)
			 || citydb_pkg.table_content(table_name, table_schema) AS t 
                FROM information_schema.tables WHERE table_schema = $1 
                AND table_name != ''database_srs'' 
                AND table_name != ''objectclass'' 
                AND table_name NOT LIKE ''tmp_%''
                ORDER BY table_name ASC
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
CREATE OR REPLACE FUNCTION citydb_pkg.table_content(
  table_name TEXT,
  schema_name TEXT DEFAULT 'citydb'
  ) RETURNS INTEGER AS $$
DECLARE
  cnt INTEGER;  
BEGIN
  EXECUTE format('SELECT count(*) FROM %I.%I', schema_name, table_name) INTO cnt;
  RETURN cnt;
END;
$$
LANGUAGE plpgsql;