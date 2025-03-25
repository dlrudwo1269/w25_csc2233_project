#!/bin/bash

source /w/340/kjlee/repos/w25_csc2233_project/.venv/bin/activate

distributions=("normal" "zipfian" "zipfian_flat" "uniform" "log_normal")
export PYTHONUNBUFFERED=1

for distribution in "${distributions[@]}"; do
    echo "Running Chroma with popularity distribution: $distribution"
    python chroma/run.py --popularity_distribution "$distribution" --output_dir "./chroma/.out"
done