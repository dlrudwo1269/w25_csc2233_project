#!/bin/bash

# Default distribution
DISTRIBUTION="normal"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --distribution)
      DISTRIBUTION="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--distribution TYPE]"
      echo "  --distribution: Distribution type (default: normal)"
      exit 1
      ;;
  esac
done

echo "Loading data with distribution=$DISTRIBUTION"

# Define the data path using the distribution parameter
DATA_PATH="$PWD/processed_data/base_vectors/sift_base_${DISTRIBUTION}.tsv"

# Check if the data file exists
if [ ! -f "$DATA_PATH" ]; then
    echo "Error: Data file not found at $DATA_PATH"
    echo "Available distribution files:"
    ls -la "$PWD/processed_data/base_vectors/" | grep "sift_base_"
    exit 1
fi

# Run the SQL script with the data path
echo "Running SQL script with data path: $DATA_PATH"
$PWD/msvbase_install/postgres/bin/psql -d vectordb -v data_path="$DATA_PATH" -f $PWD/VBase/load_data.sql

echo "Data loading completed successfully."