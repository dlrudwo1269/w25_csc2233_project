#!/bin/bash

# Get the absolute path to the project root directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Default values
SELECTIVITY=1
DISTRIBUTION="normal"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --selectivity)
      SELECTIVITY="$2"
      shift 2
      ;;
    --distribution)
      DISTRIBUTION="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--selectivity VALUE] [--distribution TYPE]"
      echo "  --selectivity: Selectivity value (must be one of: 1, 10, 50, 90, 99, 100)"
      echo "  --distribution: Distribution type (must be one of: normal, zipfian, uniform, log_normal)"
      exit 1
      ;;
  esac
done

# Validate selectivity value
if [[ ! "$SELECTIVITY" =~ ^(1|10|50|90|99|100)$ ]]; then
  echo "Error: Selectivity must be one of: 1, 10, 50, 90, 99, 100"
  echo "You provided: $SELECTIVITY"
  exit 1
fi

# Validate distribution value
if [[ ! "$DISTRIBUTION" =~ ^(normal|zipfian|uniform|log_normal)$ ]]; then
  echo "Error: Distribution must be one of: normal, zipfian, uniform, log_normal"
  echo "You provided: $DISTRIBUTION"
  exit 1
fi

echo "Running query with selectivity=$SELECTIVITY and distribution=$DISTRIBUTION"

# Define paths
PG_INSTALL_DIR="$PROJECT_DIR/msvbase_install/postgres"
RESULT_DIR="$PROJECT_DIR/result"
SQL_DIR="$PROJECT_DIR/postgres/sql"
OUTPUT_FILE="$RESULT_DIR/gt_${DISTRIBUTION}_${SELECTIVITY}.out"
SQL_FILE="${DISTRIBUTION}_threshold${SELECTIVITY}_query.sql"
SQL_PATH="$SQL_DIR/$SQL_FILE"

# Create result directory if it doesn't exist
if [ ! -d "$RESULT_DIR" ]; then
    echo "Creating result directory: $RESULT_DIR"
    mkdir -p "$RESULT_DIR"
fi

# Create sql directory if it doesn't exist
if [ ! -d "$SQL_DIR" ]; then
    echo "Creating SQL directory: $SQL_DIR"
    mkdir -p "$SQL_DIR"
fi

# Generate query based on parameters
echo "Generating query..."
python3 "$PROJECT_DIR/postgres/generate_query.py" --selectivity "$SELECTIVITY" --popularity_distribution "$DISTRIBUTION"

# Check if the query file was created
if [ ! -f "$SQL_PATH" ]; then
    echo "Error: Query file was not created at $SQL_PATH"
    echo "Check the output above for errors from generate_query.py"
    exit 1
fi

# Remove previous output file if it exists
rm -f "$OUTPUT_FILE" >/dev/null 2>&1

# Run the query and save output
echo "Running query and saving output to $OUTPUT_FILE"
"$PG_INSTALL_DIR/bin/psql" -d vectordb -f "$SQL_PATH" > "$OUTPUT_FILE"

echo "Query completed. Results saved to $OUTPUT_FILE"


