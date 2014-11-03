CREATE OR REPLACE PROCEDURE updateSequences
  IS
    -- variables --
    CURSOR user_sequences_cursor IS 
      select SUBSTR(sequence_name, 0, 
      INSTR(sequence_name, '_SEQ')-1) as sequencename 
      from user_sequences order by sequence_name;
    sequence_val NUMBER(10) := 0;
    corrected_table_name VARCHAR2(100);
    query_str VARCHAR2(1000);
    table_exists NUMBER(1) := 0;
    column_exists NUMBER(10) := 0;
  BEGIN    
    for user_sequences in user_sequences_cursor loop 
      IF (user_sequences.sequencename IS NOT NULL) THEN              
        select count(table_name) into table_exists 
        from user_tables where table_name = user_sequences.sequencename;
        
        select COUNT(*) INTO column_exists
        from all_tab_cols
        where table_name = user_sequences.sequencename and 
        column_name = 'ID';
        
        IF (column_exists != 0) THEN        
          IF (table_exists = 1) THEN          
            query_str := 'select max(id) from '|| user_sequences.sequencename;
            EXECUTE IMMEDIATE query_str into sequence_val;
            -- dbms_output.put_line(user_sequences.sequencename || ':' || sequence_val);  
            IF (sequence_val IS NOT NULL) THEN
              -- dbms_output.put_line('DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ');
              -- dbms_output.put_line('CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1));
              EXECUTE IMMEDIATE 'DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ';
              EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1);          
            END IF;   
          ELSE
             query_str := 'select table_name from user_tables where table_name 
              like ''%'
              || user_sequences.sequencename ||         
              '%''';
              -- dbms_output.put_line(query_str);
              
             EXECUTE IMMEDIATE query_str into corrected_table_name;          
             query_str := 'select max(id) from '|| corrected_table_name;
             EXECUTE IMMEDIATE query_str into sequence_val;
             -- dbms_output.put_line(user_sequences.sequencename || ':' || sequence_val); 
             IF (sequence_val IS NOT NULL) THEN       
              -- dbms_output.put_line('DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ');
              -- dbms_output.put_line('CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1));
              EXECUTE IMMEDIATE 'DROP SEQUENCE ' || user_sequences.sequencename || '_SEQ';
              EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || user_sequences.sequencename || '_SEQ START WITH ' || (sequence_val + 1);
             END IF;   
          END IF;        
        END IF;        
      END IF;            
      sequence_val := 0;
      query_str := 0;
      table_exists := 0;
      corrected_table_name := '';
    end loop;
  end;
/