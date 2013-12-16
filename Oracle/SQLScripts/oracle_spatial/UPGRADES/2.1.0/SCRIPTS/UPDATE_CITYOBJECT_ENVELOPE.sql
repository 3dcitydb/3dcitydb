-- UPDATE_CITYOBJECT_ENVELOPE.sql
--
-- Authors:     Javier Herreruela <javier.herreruela@tu-berlin.de>
--              Claus Nagel <cnagel@virtualcitysystems.de>
--
-- Copyright:   (c) 2007-2011, Institute for Geodesy and Geoinformation Science,
--                             Technische Universität Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.6     2011-12-22   fix for workspaces                          JHer
--           2011-12-16   release version                             JHer
--                                                                    CNag
--

set serveroutput on;

declare

-- variables --
  v_disable_spx varchar2(3);
  sql_error_code VARCHAR2(20);

  v_srid DATABASE_SRS.SRID%TYPE;
  v_onnc NLS_DATABASE_PARAMETERS.VALUE%TYPE;

  v_original_ordinates mdsys.sdo_ordinate_array;
  v_sqlstr varchar2(2000);
  
  err_num number;
  err_msg varchar2(1000);

  v_cityobject_counter number :=0;
  v_cityobject_ws_counter number :=0;
  v_cityobject_subcounter number :=0;
  v_commit_inteval number :=10000;

  v_not_updated_counter number :=0;

  cursor c_workspaces is select workspace as workspace_name from user_workspaces
--                         union
--                         select workspace_name as workspace_name from planning_alternative
                         union
                         select 'LIVE' as workspace_name from dual;

  cursor c_update is select co.envelope, co.id
                     from cityobject co
                     where co.envelope is not null;   


-- main program --
begin

  if geodb_idx.index_status('CITYOBJECT', 'ENVELOPE') = 'VALID' then
    v_disable_spx := UPPER('yes');
  else
    v_disable_spx := UPPER('no');
  end if;

  select srid into v_srid from database_srs;
  select value into v_onnc from nls_database_parameters where parameter = 'NLS_NUMERIC_CHARACTERS';
  -- decimal separator MUST be a point
  execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''.,''';

  if v_disable_spx = 'YES' then
    dbms_output.put_line(' ');
    dbms_output.put_line('Disabling envelope spatial index...');
    sql_error_code := geodb_idx.drop_index(geodb_idx.get_index('CITYOBJECT', 'ENVELOPE'), geodb_util.versioning_table('CITYOBJECT') = 'ON');
    if sql_error_code <> 0 then
      dbms_output.put_line('Error:' || sql_error_code);
    end if;
  end if;

  dbms_output.put_line(' ');

  for v_workspace in c_workspaces loop
    begin

      v_cityobject_ws_counter := 0;
      dbms_wm.GotoWorkspace(v_workspace.workspace_name);
      dbms_output.put_line('updating envelope contents for all cityobjects in workspace ' || v_workspace.workspace_name || ' ...');
      
      for v_cityobject in c_update loop
        begin
    
          v_original_ordinates := v_cityobject.envelope.sdo_ordinates;
          if v_cityobject.envelope.sdo_elem_info(3) = 3 then -- not updated yet
--        if v_original_ordinates.count < 7 then -- not updated yet
    
            v_sqlstr := 'UPDATE cityobject co SET co.envelope = SDO_GEOMETRY(3003, '
      	                || v_srid || ', NULL, MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 1), '
      	                || 'MDSYS.SDO_ORDINATE_ARRAY('
      
                        || v_original_ordinates(1) || ', '
                        || v_original_ordinates(2) || ', '
                        || v_original_ordinates(3) || ', '
            
                        || v_original_ordinates(4) || ', '
                        || v_original_ordinates(2) || ', '
                        || v_original_ordinates(3) || ', '
      
                        || v_original_ordinates(4) || ', '
                        || v_original_ordinates(5) || ', '
                        || v_original_ordinates(6) || ', '
      
                        || v_original_ordinates(1) || ', '
                        || v_original_ordinates(5) || ', '
                        || v_original_ordinates(6) || ', '
      
                        || v_original_ordinates(1) || ', '
                        || v_original_ordinates(2) || ', '
                        || v_original_ordinates(3)
      
                        || ')) WHERE co.id = ' || v_cityobject.id;
      
--          dbms_output.put_line('v_sqlstr := ' || v_sqlstr);
      	    execute immediate v_sqlstr;
      
            v_cityobject_counter := v_cityobject_counter + 1;
            v_cityobject_ws_counter := v_cityobject_ws_counter + 1;
            v_cityobject_subcounter := v_cityobject_subcounter + 1;
                
            if v_cityobject_subcounter = v_commit_inteval then
              v_cityobject_subcounter := 0;
--            dbms_output.put_line('currently processed cityobjects = ' || v_cityobject_counter || '; committing...');
              commit;
            end if;
    
          end if; 
    
        exception
          when others then
            dbms_output.put_line('there was possibly a problem in update loop with cityobject ' || v_cityobject.id);
            err_num := SQLCODE;
            err_msg := SUBSTR(SQLERRM, 1, 100);
            dbms_output.put_line('err_num = ' || err_num || '; err_msg = ' || err_msg);
            v_not_updated_counter := v_not_updated_counter + 1;
        end;
    
      end loop; -- update loop
  
      dbms_output.put_line('processed cityobjects in workspace ' || v_workspace.workspace_name || ' = ' || v_cityobject_ws_counter || '; committing...');
      commit; -- the rest
  
    exception
      when others then
        dbms_output.put_line('there was possibly a problem in workspace loop with workspace ' || v_workspace.workspace_name);
        err_num := SQLCODE;
        err_msg := SUBSTR(SQLERRM, 1, 100);
        dbms_output.put_line('err_num = ' || err_num || '; err_msg = ' || err_msg);
        v_not_updated_counter := v_not_updated_counter + 1;
    end;
  
  end loop; -- workspace loop

  execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''' || v_onnc || '''';
  dbms_wm.GotoWorkspace('LIVE');

  dbms_output.put_line('total processed cityobjects = ' || v_cityobject_counter);

  if v_disable_spx = 'YES' then
    dbms_output.put_line(' ');
    dbms_output.put_line('Enabling envelope spatial index. This can take long time...');
    sql_error_code := geodb_idx.create_index(geodb_idx.get_index('CITYOBJECT', 'ENVELOPE'), geodb_util.versioning_table('CITYOBJECT') = 'ON');
    if sql_error_code <> 0 then
      dbms_output.put_line('Error:' || sql_error_code);
    end if;
  end if;
  
  dbms_output.put_line(' ');
  if v_not_updated_counter = 0 then
    dbms_output.put_line('update_cityobject_envelope.sql successfully finished.');
  else
    dbms_output.put_line('update_cityobject_envelope.sql finished with errors.');
  end if;

exception
  when others then
    dbms_output.put_line(' ');
    dbms_output.put_line('update_cityobject_envelope.sql finished with errors.');

    execute immediate 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ''' || v_onnc || '''';
    dbms_wm.GotoWorkspace('LIVE');

end;
/