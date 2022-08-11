-- FUNCTION citydb.cleanup_schema() RETURNS SETOF void
------------------------------------------
CREATE OR REPLACE FUNCTION citydb.cleanup_schema() RETURNS SETOF void AS
$body$
DECLARE
rec RECORD;
BEGIN
FOR rec IN
SELECT table_name FROM information_schema.tables where table_schema = 'citydb'
        AND table_name <> 'database_srs'
        AND table_name <> 'objectclass'
        AND table_name <> 'index_table'
        AND table_name <> 'ade'
        AND table_name NOT LIKE 'tmp_%'
  LOOP
    EXECUTE format('TRUNCATE TABLE citydb.%I CASCADE', rec.table_name);
END LOOP;

FOR rec IN
SELECT sequence_name FROM information_schema.sequences where sequence_schema = 'citydb'
        AND sequence_name <> 'ade_seq'
  LOOP
    EXECUTE format('ALTER SEQUENCE citydb.%I RESTART', rec.sequence_name);
END LOOP;
END;
$body$
LANGUAGE plpgsql;
------------------------------------------