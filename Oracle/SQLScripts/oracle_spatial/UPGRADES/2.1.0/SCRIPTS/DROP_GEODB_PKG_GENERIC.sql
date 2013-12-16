-- DROP_GEODB_PKG_GENERIC.sql
--
-- Authors:     Javier Herreruela <javier.herreruela@tu-berlin.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2011  Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Drops subpackages "geodb_*".
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 1.0.0     2011-05-16   release version                             JHer
-- 1.0.1     2011-07-28   update to version 2.0.6                     CNag
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


   PROCEDURE truncate_table_if_exists (v_table_name varchar2) IS
   BEGIN
     IF user_object_exists('Table', v_table_name) <> 0 THEN
       EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || v_table_name;
       dbms_output.put_line('Table ' || v_table_name || ' truncated');
     END IF;
   END; -- PROCEDURE truncate_table_if_exists

-- main

BEGIN

  dbms_output.put_line('Starting GEODB package deletion...');

  --// drop global types
  drop_user_object_if_exists('Type', 'STRARRAY');
  drop_user_object_if_exists('Type', 'INDEX_OBJ');
  drop_user_object_if_exists('Type', 'DB_INFO_TABLE');
  drop_user_object_if_exists('Type', 'DB_INFO_OBJ');
   
  --// drop packages
  drop_user_object_if_exists('Package', 'geodb_util');
  drop_user_object_if_exists('Package', 'geodb_idx');
  drop_user_object_if_exists('Package', 'geodb_stat');

  drop_user_object_if_exists('Package', 'geodb_match');
  drop_user_object_if_exists('Package', 'geodb_process_matches');
  drop_user_object_if_exists('Package', 'geodb_delete_by_lineage');

  drop_user_object_if_exists('Package', 'geodb_delete');
  drop_user_object_if_exists('Package', 'geodb_merge');

  --// drop tables
  drop_user_object_if_exists('Table', 'match_result');
  drop_user_object_if_exists('Table', 'match_master_aggr_geom');
  drop_user_object_if_exists('Table', 'match_cand_aggr_geom');
  drop_user_object_if_exists('Table', 'match_allocate_geom');
  truncate_table_if_exists('match_tmp_building');
  drop_user_object_if_exists('Table', 'match_tmp_building');

  truncate_table_if_exists('match_result_relevant');
  drop_user_object_if_exists('Table', 'match_result_relevant');
  drop_user_object_if_exists('Table', 'collect_geom');
  drop_user_object_if_exists('Table', 'container_ids');

  drop_user_object_if_exists('Table', 'match_overlap_all');
  drop_user_object_if_exists('Table', 'match_overlap_relevant');
  drop_user_object_if_exists('Table', 'match_master_projected');
  drop_user_object_if_exists('Table', 'match_cand_projected');
  drop_user_object_if_exists('Table', 'match_collect_geom');
  drop_user_object_if_exists('Table', 'merge_collect_geom');
  truncate_table_if_exists('merge_container_ids');
  drop_user_object_if_exists('Table', 'merge_container_ids');

  dbms_output.put_line('GEODB package deletion complete!');
  dbms_output.put_line('');

END;
/

