chmod +x $PWD/postgres/load_data.sh
$PWD/postgres/load_data.sh
chmod +x $PWD/postgres/query.sh
$PWD/postgres/query.sh --selectivity 0.5 --distribution uniform