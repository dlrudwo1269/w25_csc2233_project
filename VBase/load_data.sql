create database test_db;
\c test_db;

CREATE EXTENSION vectordb;

create table sift_table(vector_id int PRIMARY KEY, popularity float8, sift_vector float8[128]);
alter table sift_table alter sift_vector set storage plain;

copy sift_table from 'processed_data/base_vectors/sift_base_<distribution-name>.tsv' DELIMITER E'\t' csv quote e'\x01';

create index hnsw_index on sift_table using hnsw(sift_vector hnsw_vector_inner_product_ops) with(dimension=128, distmethod=inner_product);
create index bindex on sift_table(popularity);
