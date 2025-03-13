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

# Make setup.sh executable
chmod +x $PWD/setup.sh

# Run setup.sh and check if it succeeds
echo "Running setup.sh..."
if ! $PWD/setup.sh; then
    echo "Setup failed. Retrying once..."
    sleep 3
    # Retry setup.sh once
    if ! $PWD/setup.sh; then
        echo "Setup failed again. Exiting."
        exit 1
    fi
fi

# Continue with the rest of the script
chmod +x $PWD/data_prepare/data_prepare.sh
$PWD/data_prepare/data_prepare.sh
rm -rf raw_data

# Make the PostgreSQL run script executable
chmod +x $PWD/postgres/run.sh

# Run the PostgreSQL script with the parameters
$PWD/postgres/run.sh --distribution $DISTRIBUTION --selectivity $SELECTIVITY