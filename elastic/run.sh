#!/bin/bash

HOME_DIR="/w/331/kjlee"

source $HOME_DIR/w25_csc2233_project/.venv/bin/activate
echo "Using python: $(which python)"

export PYTHONUNBUFFERED=1

# Start elasticsearch server as a daemon (i.e., in the background)
$HOME_DIR/elasticsearch-8.17.3/bin/elasticsearch -d

if [ $# -eq 0 ]; then
    echo "Error: Please specify a distribution as an argument"
    echo "Available distributions: normal zipfian zipfian_flat uniform log_normal"
    exit 1
fi

distribution=$1

echo "Running Elastic with popularity distribution: $distribution"
python $HOME_DIR/w25_csc2233_project/elastic/run.py --popularity_distribution "$distribution" --output_dir "$HOME_DIR/w25_csc2233_project/elastic/.out"
