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
      echo "  --selectivity: Selectivity value (default: 1)"
      echo "  --distribution: Distribution type (default: normal)"
      exit 1
      ;;
  esac
done

echo "Running query with selectivity=$SELECTIVITY and distribution=$DISTRIBUTION"

# Define paths
PG_INSTALL_DIR="$PROJECT_DIR/msvbase_install/postgres"
RESULT_DIR="$PROJECT_DIR/result"
SQL_DIR="$PROJECT_DIR/postgres/sql"
OUTPUT_FILE="$RESULT_DIR/gt_${DISTRIBUTION}_${SELECTIVITY}.out"

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

rm -f "$OUTPUT_FILE" >/dev/null 2>&1

# Run the query and save output
echo "Running query and saving output to $OUTPUT_FILE"
"$PG_INSTALL_DIR/bin/psql" -d vectordb -f "$PROJECT_DIR/postgres/sql/${DISTRIBUTION}_threshold${SELECTIVITY}_query.sql" > "$OUTPUT_FILE"

echo "Query completed. Results saved to $OUTPUT_FILE"


