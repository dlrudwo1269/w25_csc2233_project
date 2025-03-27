#!/bin/bash

source /w/331/kjlee/w25_csc2233_project/.venv/bin/activate

export PYTHONUNBUFFERED=1

if [ $# -eq 0 ]; then
    echo "Error: Please specify a distribution as an argument"
    echo "Available distributions: normal zipfian zipfian_flat uniform log_normal"
    exit 1
fi

distribution=$1

echo "Running Chroma with popularity distribution: $distribution"
python chroma/run.py --popularity_distribution "$distribution" --output_dir "./chroma/.out"