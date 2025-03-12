chmod +x $PWD/postgres/load_data.sh
$PWD/postgres/load_data.sh --distribution uniform
chmod +x $PWD/postgres/query.sh
$PWD/postgres/query.sh --selectivity 0.5 --distribution uniform