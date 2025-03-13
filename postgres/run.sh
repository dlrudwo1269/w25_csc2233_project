chmod +x $PWD/postgres/load_data.sh
$PWD/postgres/load_data.sh --distribution normal
chmod +x $PWD/postgres/query.sh
$PWD/postgres/query.sh --selectivity 10 --distribution normal