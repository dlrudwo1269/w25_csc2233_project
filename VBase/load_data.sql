-- Create the extension if it doesn't exist
CREATE EXTENSION IF NOT EXISTS vectordb;

CREATE TABLE IF NOT EXISTS sift_table (
    vector_id int PRIMARY KEY,
    popularity float8,
    sift_vector float8[128]
);

-- Alter the table to set storage if it exists
ALTER TABLE sift_table ALTER sift_vector SET STORAGE PLAIN;

-- Copy data into the table
COPY sift_table FROM :'data_path' DELIMITER E'\t' CSV QUOTE E'\x01';

create index if not exists hnsw_index on sift_table using hnsw(sift_vector hnsw_vector_inner_product_ops) with(dimension=128, distmethod=inner_product);

-- Create the index if it doesn't exist
create index if not exists bindex on sift_table(popularity);

