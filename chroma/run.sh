#!/bin/bash

source /w/340/kjlee/repos/w25_csc2233_project/.venv/bin/activate

distributions=("normal" "zipfian" "uniform" "log_normal")

for distribution in "${distributions[@]}"; do
    python chroma/run.py --popularity_distribution "$distribution" --output_dir "./chroma/.out"
done