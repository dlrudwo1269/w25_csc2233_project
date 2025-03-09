
python3 ./generate_query.py

rm ./result/gt.out >/dev/null 2>&1
#cp /tmp/vectordb/eval_src/hnswindex_ef_200.cpp /tmp/vectordb/src/hnswindex.cpp && cd /tmp/vectordb/build && make -j40  >/dev/null 2>&1 && make install >/dev/null 2>&1
#echo "Start to run vbase query 2 in Table-5 of paper"


psql -U vectordb -f ./sql/query.sql > ./result/gt.out


