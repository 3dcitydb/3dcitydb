-- check the PostgreSQL version
DO $$
DECLARE
  required_major_version CONSTANT int := @majorVersion@;
  server_version_num int := current_setting('server_version_num')::int;
BEGIN
  IF server_version_num / 10000 < required_major_version THEN
    RAISE EXCEPTION 'PostgreSQL version % is not supported. Version % or newer is required.',
      current_setting('server_version'), required_major_version;
  END IF;
END
$$;
