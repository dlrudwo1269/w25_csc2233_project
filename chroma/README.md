# ChromaDB
## Installation
Install ChromaDB's Python client.
```bash
pip install chromadb
```

## Run
The library makes available both the server and client, so there is no additional setup required. Just configure the directories in `run.sh` and run `chroma/run.sh <distribution>`. This will index the data for the given distribution, perform the queries for each selectivity, and write the results to `chroma/.out`.
