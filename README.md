# w25_csc2233_project

## Experiment Reproduction
### Environment Setup
TODO

### Data Preparation
At the root directory of the project, run
```bash
./data_prepare/data_prepare.sh
```

This will download the SIFT1M base vectors and query vectors save them in .tsv format under `/processed_data/base_vectors` and `/processed_data/queries`, respectively. We generate multiple copies of the base vectors, augmented with popularity metadata sampled from different distributions (one of Normal, Zipfian (a=2.0), Zipfian flat (a=1.1), Uniform, and Log Normal). The selectivity information for each of these distrubutions can be found under `/processed_data/selectivity_stats`.

### Root Directory Scripts

#### `run.sh`
The main entry point script that generate the Postgres ground truth for a given distribution and selectivity.

**Usage:**
```bash
./run.sh [--distribution TYPE] [--selectivity VALUE]
```

**Parameters:**
- `--distribution`: Type of popularity distribution (normal, zipfian, uniform, log_normal)
- `--selectivity`: Selectivity value for queries (1, 10, 50, 90, 99, 100)

**Functionality:**
1. Runs setup.sh to initialize the environment
2. Prepares data using data_prepare.sh
3. Runs PostgreSQL experiments with the specified distribution and selectivity
4. Cleans up the database after experiments

#### `setup.sh`
Sets up the environment by installing and configuring PostgreSQL with the vectordb extension.

**Functionality:**
1. Installs required dependencies (Boost, CMake) locally
2. Clones and builds MSVBASE repository
3. Builds PostgreSQL from source with vectordb extension
4. Initializes PostgreSQL database
5. Starts PostgreSQL server

### PostgreSQL Scripts

#### `postgres/run.sh`
Coordinates the PostgreSQL experiment workflow.

**Usage:**
```bash
./postgres/run.sh [--distribution TYPE] [--selectivity VALUE]
```

**Parameters:**
- `--distribution`: Type of popularity distribution (normal, zipfian, uniform, log_normal)
- `--selectivity`: Selectivity value for queries (1, 10, 50, 90, 99, 100)

**Functionality:**
1. Loads data into PostgreSQL using load_data.sh
2. Runs queries using query.sh with specified parameters

#### `postgres/query.sh`
Executes queries against the PostgreSQL database.

**Usage:**
```bash
./postgres/query.sh [--selectivity VALUE] [--distribution TYPE] [--top_k VALUE]
```

**Parameters:**
- `--selectivity`: Selectivity value (1, 10, 50, 90, 99, 100)
- `--distribution`: Distribution type (normal, zipfian, uniform, log_normal)
- `--top_k`: Number of top results to retrieve (default: 50)

**Functionality:**
1. Validates input parameters
2. Generates SQL query based on parameters
3. Executes the query against PostgreSQL
4. Saves results to output file

### Evaluation
TODO

