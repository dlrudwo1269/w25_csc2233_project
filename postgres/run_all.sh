#!/bin/sh
chmod +x ./postgres/run_experiment.sh

./postgres/run_experiment.sh --distribution normal --selectivity 1
./postgres/run_experiment.sh --distribution normal --selectivity 10
./postgres/run_experiment.sh --distribution normal --selectivity 50
./postgres/run_experiment.sh --distribution normal --selectivity 90
./postgres/run_experiment.sh --distribution normal --selectivity 99


./postgres/run_experiment.sh --distribution zipfian --selectivity 1
./postgres/run_experiment.sh --distribution zipfian --selectivity 10
./postgres/run_experiment.sh --distribution zipfian --selectivity 50
./postgres/run_experiment.sh --distribution zipfian --selectivity 90
./postgres/run_experiment.sh --distribution zipfian --selectivity 99

./postgres/run_experiment.sh --distribution uniform --selectivity 1
./postgres/run_experiment.sh --distribution uniform --selectivity 10
./postgres/run_experiment.sh --distribution uniform --selectivity 50
./postgres/run_experiment.sh --distribution uniform --selectivity 90
./postgres/run_experiment.sh --distribution uniform --selectivity 99


./postgres/run_experiment.sh --distribution log_normal --selectivity 1
./postgres/run_experiment.sh --distribution log_normal --selectivity 10
./postgres/run_experiment.sh --distribution log_normal --selectivity 50
./postgres/run_experiment.sh --distribution log_normal --selectivity 90
./postgres/run_experiment.sh --distribution log_normal --selectivity 99

./postgres/run_experiment.sh --distribution zipfian_flat --selectivity 1
./postgres/run_experiment.sh --distribution zipfian_flat --selectivity 10
./postgres/run_experiment.sh --distribution zipfian_flat --selectivity 50
./postgres/run_experiment.sh --distribution zipfian_flat --selectivity 90
./postgres/run_experiment.sh --distribution zipfian_flat --selectivity 99