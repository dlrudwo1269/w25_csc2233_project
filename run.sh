#!/bin/bash

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

# Run the PostgreSQL script
$PWD/postgres/run.sh