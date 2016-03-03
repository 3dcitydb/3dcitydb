-- DROP_CITYDB_PKG.sql
--
-- Authors:     Javier Herreruela <javier.herreruela@tu-berlin.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--              Felix Kunde <felix-kunde@gmx.de>
--
-- Copyright:   (c) 2012-2016  Chair of Geoinformatics,
--                            Technische Universität München, Germany
--                            http://www.gis.bv.tum.de
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
-- Drops subpackages "citydb_*".
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.2     2015-11-05   update to version 3.1                       FKun
-- 1.0.1     2011-07-28   update to version 2.0.6                     CNag
-- 1.0.0     2011-05-16   release version                             JHer
--

SET SERVEROUTPUT ON;

DECLARE

-- functions  
  FUNCTION user_object_exists(v_object_type varchar2, v_object_name varchar2) RETURN number IS
    v_object_exists number := 0;
  BEGIN
    SELECT COUNT(*) INTO v_object_exists FROM user_objects
      WHERE object_type = UPPER(v_object_type)
        AND object_name = UPPER(v_object_name);
   
    RETURN v_object_exists;
  END; -- FUNCTION user_object_exists


-- procedures
   PROCEDURE drop_user_object_if_exists (v_object_type varchar2, v_object_name varchar2) IS
   BEGIN
     IF user_object_exists(v_object_type, v_object_name) <> 0 THEN
       EXECUTE IMMEDIATE 'DROP '|| v_object_type || ' ' || v_object_name;
       dbms_output.put_line(v_object_type || ' ' || v_object_name || ' deleted');
     END IF;
   END; -- PROCEDURE drop_user_object_if_exists

-- main

BEGIN

  dbms_output.put_line('Starting CITYDB package deletion...');

  --// drop global sequences
  drop_user_object_if_exists('Sequence', 'INDEX_TABLE_SEQ');
  
  --// drop global tables
  drop_user_object_if_exists('Table', 'INDEX_TABLE');

  --// drop global types
  drop_user_object_if_exists('Type', 'STRARRAY');
  drop_user_object_if_exists('Type', 'ID_ARRAY');
  drop_user_object_if_exists('Type', 'INDEX_OBJ');
  drop_user_object_if_exists('Type', 'DB_INFO_TABLE');
  drop_user_object_if_exists('Type', 'DB_INFO_OBJ');
  drop_user_object_if_exists('Type', 'DB_VERSION_TABLE');
  drop_user_object_if_exists('Type', 'DB_VERSION_OBJ');
   
  --// drop packages
  drop_user_object_if_exists('Package', 'citydb_util');
  drop_user_object_if_exists('Package', 'citydb_idx');
  drop_user_object_if_exists('Package', 'citydb_srs');
  drop_user_object_if_exists('Package', 'citydb_stat');
  drop_user_object_if_exists('Package', 'citydb_delete_by_lineage');
  drop_user_object_if_exists('Package', 'citydb_delete');

  dbms_output.put_line('CITYDB package deletion complete!');
  dbms_output.put_line('');

END;
/

