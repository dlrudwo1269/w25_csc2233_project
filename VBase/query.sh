#!/bin/bash

# Get the absolute path to the project root directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Default values
SELECTIVITY=1
DISTRIBUTION="normal"
TOP_K=50

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
    --top_k)
      TOP_K="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--selectivity VALUE] [--distribution TYPE] [--top_k VALUE]"
      echo "  --selectivity: Selectivity value (must be one of: 1, 10, 50, 90, 99, 100)"
      echo "  --distribution: Distribution type (must be one of: normal, zipfian, uniform, log_normal)"
      echo "  --top_k: Number of top results to retrieve (default: 50)"
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

echo "Running query with selectivity=$SELECTIVITY, distribution=$DISTRIBUTION, top_k=$TOP_K"

# Define paths
PG_INSTALL_DIR="$PROJECT_DIR/msvbase_install/postgres"
RESULT_DIR="$PROJECT_DIR/result"
SQL_DIR="$PROJECT_DIR/vbase/sql"
OUTPUT_FILE="$RESULT_DIR/vbase_${DISTRIBUTION}_${SELECTIVITY}.out"
SQL_FILE="${DISTRIBUTION}_threshold${SELECTIVITY}_query.sql"
SQL_PATH="$SQL_DIR/$SQL_FILE"
SELECTIVITY_STATS_PATH="$PROJECT_DIR/processed_data/selectivity_stats/sift_base_${DISTRIBUTION}_stats.txt"

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
cd "$PROJECT_DIR"  # Change to project directory before running the Python script
python3 "$PROJECT_DIR/VBase/generate_query.py" \
  --selectivity "$SELECTIVITY" \
  --popularity_distribution "$DISTRIBUTION" \
  --output_path "$SQL_PATH" \
  --top_k "$TOP_K" \
  --selectivity_stats_path "$SELECTIVITY_STATS_PATH"

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


