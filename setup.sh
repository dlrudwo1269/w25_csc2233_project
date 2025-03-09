git clone https://github.com/microsoft/MSVBASE.git
cd MSVBASE
git submodule update --init --recursive ./thirdparty/hnsw 
git submodule update --init --recursive ./thirdparty/Postgres 
# git submodule update --init --recursive
# spann submodule has dataset which takes up disk space and exceeds disk quota
./scripts/patch.sh

./scripts/dockerbuild.sh
./scripts/dockerrun.sh

docker exec -it --privileged --user=root vbase_open_source bash
