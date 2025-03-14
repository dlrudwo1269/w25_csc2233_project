#!/bin/sh
chmod +x run.sh

./run.sh --distribution normal --selectivity 1
./run.sh --distribution normal --selectivity 10
./run.sh --distribution normal --selectivity 50
./run.sh --distribution normal --selectivity 90
./run.sh --distribution normal --selectivity 99
./run.sh --distribution normal --selectivity 100


./run.sh --distribution zipfian --selectivity 1
./run.sh --distribution zipfian --selectivity 10
./run.sh --distribution zipfian --selectivity 50
./run.sh --distribution zipfian --selectivity 90
./run.sh --distribution zipfian --selectivity 99
./run.sh --distribution zipfian --selectivity 100

./run.sh --distribution uniform --selectivity 1
./run.sh --distribution uniform --selectivity 10
./run.sh --distribution uniform --selectivity 50
./run.sh --distribution uniform --selectivity 90
./run.sh --distribution uniform --selectivity 99
./run.sh --distribution uniform --selectivity 100


./run.sh --distribution log_normal --selectivity 1
./run.sh --distribution log_normal --selectivity 10
./run.sh --distribution log_normal --selectivity 50
./run.sh --distribution log_normal --selectivity 90
./run.sh --distribution log_normal --selectivity 99
./run.sh --distribution log_normal --selectivity 100