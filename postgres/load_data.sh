
$PWD/msvbase_install/postgres/bin/psql -d vectordb -v data_path="'$PWD/processed_data/base_vectors/sift_base_normal.tsv'" -f $PWD/postgres/load_data.sql