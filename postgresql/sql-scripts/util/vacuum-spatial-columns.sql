SELECT 'VACUUM ANALYZE '|| f_table_schema || '.'|| f_table_name || '(' || f_geometry_column || ');' AS vacuum_spatial_columns
  FROM geometry_columns;
\gexec