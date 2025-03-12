-- Check if the database exists and create it if it doesn't
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database
      WHERE datname = 'test_db'
   ) THEN
      PERFORM dblink_exec('dbname=postgres', 'CREATE DATABASE test_db');
   END IF;
END
$$;

-- Connect to the database
\c test_db;

-- Create the extension if it doesn't exist
CREATE EXTENSION IF NOT EXISTS vectordb;

CREATE TABLE IF NOT EXISTS sift_table (
    vector_id int PRIMARY KEY,
    popularity float8,
    sift_vector float8[128]
);

-- Alter the table to set storage if it exists
DO
$$
BEGIN
   IF EXISTS (
      SELECT FROM information_schema.tables 
      WHERE table_name = 'sift_table'
   ) THEN
      ALTER TABLE sift_table ALTER sift_vector SET STORAGE PLAIN;
   END IF;
END
$$;

-- Copy data into the table
COPY sift_table FROM :'data_path' DELIMITER E'\t' CSV QUOTE E'\x01';

-- Create the index if it doesn't exist
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_indexes
      WHERE tablename = 'sift_table' AND indexname = 'bindex'
   ) THEN
      CREATE INDEX bindex ON sift_table(popularity);
   END IF;
END
$$;
