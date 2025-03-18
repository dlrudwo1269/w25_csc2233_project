#!/bin/bash

# Default values
DISTRIBUTION="normal"
SELECTIVITY=10

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --distribution)
      DISTRIBUTION="$2"
      shift 2
      ;;
    --selectivity)
      SELECTIVITY="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--distribution TYPE] [--selectivity VALUE]"
      exit 1
      ;;
  esac
done

# Run load_data.sh with the distribution parameter
chmod +x $PWD/postgres/load_data.sh
$PWD/postgres/load_data.sh --distribution $DISTRIBUTION

# Run query.sh with both distribution and selectivity parameters
chmod +x $PWD/postgres/query.sh
$PWD/postgres/query.sh --selectivity $SELECTIVITY --distribution $DISTRIBUTION