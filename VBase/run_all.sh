#!/bin/sh
chmod +x run_experiment.sh

./VBase/run_experiment.sh --distribution normal --selectivity 1
./VBase/run_experiment.sh --distribution normal --selectivity 10
./VBase/run_experiment.sh --distribution normal --selectivity 50
./VBase/run_experiment.sh --distribution normal --selectivity 90
./VBase/run_experiment.sh --distribution normal --selectivity 99


./VBase/run_experiment.sh --distribution zipfian --selectivity 1
./VBase/run_experiment.sh --distribution zipfian --selectivity 10
./VBase/run_experiment.sh --distribution zipfian --selectivity 50
./VBase/run_experiment.sh --distribution zipfian --selectivity 90
./VBase/run_experiment.sh --distribution zipfian --selectivity 99

./VBase/run_experiment.sh --distribution uniform --selectivity 1
./VBase/run_experiment.sh --distribution uniform --selectivity 10
./VBase/run_experiment.sh --distribution uniform --selectivity 50
./VBase/run_experiment.sh --distribution uniform --selectivity 90
./VBase/run_experiment.sh --distribution uniform --selectivity 99


./VBase/run_experiment.sh --distribution log_normal --selectivity 1
./VBase/run_experiment.sh --distribution log_normal --selectivity 10
./VBase/run_experiment.sh --distribution log_normal --selectivity 50
./VBase/run_experiment.sh --distribution log_normal --selectivity 90
./VBase/run_experiment.sh --distribution log_normal --selectivity 99

./VBase/run_experiment.sh --distribution zipfian_flat --selectivity 1
./VBase/run_experiment.sh --distribution zipfian_flat --selectivity 10
./VBase/run_experiment.sh --distribution zipfian_flat --selectivity 50
./VBase/run_experiment.sh --distribution zipfian_flat --selectivity 90
./VBase/run_experiment.sh --distribution zipfian_flat --selectivity 99