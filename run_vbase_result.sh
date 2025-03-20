#!/bin/sh
chmod +x run_vbase_experiment.sh

./run_vbase_experiment.sh --distribution normal --selectivity 1
./run_vbase_experiment.sh --distribution normal --selectivity 10
./run_vbase_experiment.sh --distribution normal --selectivity 50
./run_vbase_experiment.sh --distribution normal --selectivity 90
./run_vbase_experiment.sh --distribution normal --selectivity 99
./run_vbase_experiment.sh --distribution normal --selectivity 100


./run_vbase_experiment.sh --distribution zipfian --selectivity 1
./run_vbase_experiment.sh --distribution zipfian --selectivity 10
./run_vbase_experiment.sh --distribution zipfian --selectivity 50
./run_vbase_experiment.sh --distribution zipfian --selectivity 90
./run_vbase_experiment.sh --distribution zipfian --selectivity 99
./run_vbase_experiment.sh --distribution zipfian --selectivity 100

./run_vbase_experiment.sh --distribution uniform --selectivity 1
./run_vbase_experiment.sh --distribution uniform --selectivity 10
./run_vbase_experiment.sh --distribution uniform --selectivity 50
./run_vbase_experiment.sh --distribution uniform --selectivity 90
./run_vbase_experiment.sh --distribution uniform --selectivity 99
./run_vbase_experiment.sh --distribution uniform --selectivity 100


./run_vbase_experiment.sh --distribution log_normal --selectivity 1
./run_vbase_experiment.sh --distribution log_normal --selectivity 10
./run_vbase_experiment.sh --distribution log_normal --selectivity 50
./run_vbase_experiment.sh --distribution log_normal --selectivity 90
./run_vbase_experiment.sh --distribution log_normal --selectivity 99
./run_vbase_experiment.sh --distribution log_normal --selectivity 100