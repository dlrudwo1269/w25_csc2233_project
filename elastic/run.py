import argparse
import csv
import os
import time

from elasticsearch import Elasticsearch
from elasticsearch.helpers import bulk

SELECTIVITIES = [1, 10, 50, 90, 99]


def init_hnsw_index(client, index_name):
    # Ensure index does not exist
    client.indices.delete(index=index_name, ignore_unavailable=True)
    
    # Configure index settings
    index_mappings = {
        "properties": {
            "sift_vector": {
                "type": "dense_vector",
                "element_type": "float",
                "dims": 128,
                "index": "true",
                "index_options": {
                    "type": "hnsw",
                    "m": 16,
                    "ef_construction": 200,
                },
                # "dot_product" requires vectors to be pre-normalized, so use "max_inner_product" instead
                "similarity": "max_inner_product",
            },
            "popularity": {
                "type": "float",
            },
            # NOTE: _id is not configurable in mapping, so no need to worry about it here
            # https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-id-field.html
        }
    }

    client.indices.create(index=index_name, mappings=index_mappings)
    print(f"Initialized index {index_name}")


def gen_base_vectors(data_path):
    """Reads the tsv file at data_path and yields a single document for each row.
    This function is passed into the elasticsearch bulk() helper for indexing.
    """
    count = 0
    with open(data_path, 'r', encoding="utf8") as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            embedding = row[2].strip().strip("{}")
            embedding = [float(x) for x in embedding.split(",")]
            doc = {
                "_id": row[0],
                "popularity": float(row[1]),
                "sift_vector": embedding,
            }
            yield doc

            count += 1
            if count % 10000 == 0:
                print(f"Indexed {count} vectors...")


def read_selectivity_stats(stats_path):
    """Reads a file containing selectivity statistics and returns a dictionary
    of percentiles to threshold values.
    
    Selectivity statistics file format:
        - First line: "Popularity distribution: min=..., max=..."
        - Subsequent lines: "Popularity {x}th percentile: {threshold}"
    """
    selectivities = {}
    with open(stats_path, "r", encoding="utf8") as f:
        lines = f.readlines()[1:] # skip first line
        for line in lines:
            words = line.split(" ")
            selectivity = int(words[1].removesuffix("th"))
            threshold = float(words[-1])
            selectivities[selectivity] = threshold
    return selectivities


def load_queries(queries_path):
    queries = []
    with open(queries_path, 'r', encoding="utf8") as f:
        for query in f:
            query = query.strip().strip("{}")
            queries.append([float(x) for x in query.split(", ")])
    return queries


def run_queries(client, index_name, queries, popularity_threshold, top_k):
    results = []
    latencies = []
    errors = 0
    for query in queries:
        # Run queries one by one to avoid interference
        try:
            response = client.search(
                index=index_name,
                knn={
                    "field": "sift_vector",
                    "query_vector": query,
                    "k": top_k,
                    # NOTE: num_candidates is equivalent to ef_search
                    # https://www.elastic.co/search-labs/blog/simplifying-knn-search
                    # https://discuss.elastic.co/t/how-to-handle-ef-and-num-candidates-parameters-in-hnsw-search/318681
                    "num_candidates": 64,
                    "filter": {"range": {"popularity": {"lte": popularity_threshold}}},
                },
                size=top_k, # this needs to be set along with top_k, otherwise results will be paginated
                request_timeout=30,
            )
            latencies.append(float(response["took"]))
            result = [int(result["_id"]) for result in response["hits"]["hits"]]
            if len(result) < top_k:
                # pad with -1 to top_k results (if we retrieve less than top_k results for some reason)
                result += [-1] * (top_k - len(result))
            results.append(result)
            
        except Exception as e:
            print(f"ERROR: {e}")
            errors += 1

        if len(results) % 1000 == 0:
            print(f"Completed {len(results)} queries")
    
    print(f"Search on {index_name} with threshold {popularity_threshold} completed with {errors} errors!")

    return results, latencies



def main(popularity_distribution, queries_path, selectivity_stats_path, data_path, output_dir, top_k):
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Obtain Elasticsearch client
    ELASTIC_PASSWORD = os.environ['ELASTIC_PASSWORD']
    ELASTIC_HOME = os.environ['ES_HOME']

    client = Elasticsearch(
        "https://localhost:9200",
        ca_certs=os.path.join(ELASTIC_HOME, "config/certs/http_ca.crt"),
        basic_auth=("elastic", ELASTIC_PASSWORD)
    )

    start_time = time.time()
    # Load SIFT1M data and construct index
    index_name = f"sift1m_{popularity_distribution}_hnsw"
    init_hnsw_index(client, index_name)
    print("Indexing SIFT1M vectors...")
    success, errors = bulk(
        client=client, index=index_name, actions=gen_base_vectors(data_path)
    )
    print(f"Indexing complete ({success} successes, {len(errors)} errors)")
    end_time = time.time()
    print(f"Indexing took {end_time - start_time} seconds")

    # Run and benchmark queries
    selectivity_stats = read_selectivity_stats(selectivity_stats_path)
    queries = load_queries(queries_path)
    for selectivity in SELECTIVITIES:
        popularity_threshold = selectivity_stats[selectivity]
        results, latencies = run_queries(
            client, index_name, queries, popularity_threshold, top_k
        )

        # Log results
        filename = f"elastic_{popularity_distribution}_{selectivity}.out"
        with open(os.path.join(output_dir, filename), "w", encoding="utf8") as out:
            for top_k_vectors, latency in zip(results, latencies):
                # Match format of VBase eval pipeline
                out.write("Timing is on.\n")
                out.write("vector_id\n") 
                out.write("-----------\n")
                for vid in top_k_vectors:
                    out.write(f"{vid:>10}\n") # right-justify with width of 10
                out.write(f"({len(top_k_vectors)} rows)\n\n")
                out.write(f"Time: {latency} ms\n")
                out.write("Timing is off.\n")

    # Clean up index to free up storage
    client.indices.delete(index=index_name, ignore_unavailable=False)


if __name__ == "__main__":
    # Usage: python elastic/run.py --popularity_distribution [DISTRIBUTION]  --output_dir ./elastic/.out
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--popularity_distribution",
        choices=["normal", "zipfian", "zipfian_flat", "uniform", "log_normal"],
        required=True,
        help="Distribution over which the popularity metadata is sampled"
    )
    parser.add_argument(
        "--selectivity_stats_path", type=str, help="Path to the selectivity stats file"
    )
    parser.add_argument(
        "--data_path", type=str, help="Path to the data tsv file",
    )
    parser.add_argument(
        "--queries_path", type=str, default="processed_data/queries/sift_query.tsv",
        help="Path to the queries fvecs file."
    )
    parser.add_argument(
        "--output_dir", type=str, help="Directory to store results", required=True
    )
    parser.add_argument(
        "--top_k", type=int, default=50, help="How many top k results to get"
    )
    args = parser.parse_args()

    if not args.popularity_distribution and not args.selectivity_stats_path:
        raise ValueError("Please provide either a popularity distribution or path to the selectivity stats file.")
    elif args.popularity_distribution:
        selectivity_stats_path = f"processed_data/selectivity_stats/sift_base_{args.popularity_distribution}_stats.txt"
    else:
        selectivity_stats_path = args.selectivity_stats_path

    if not args.popularity_distribution and not args.data_path:
        raise ValueError("Please provide either a popularity distribution or the data file name.")
    elif args.popularity_distribution:
        data_path = f"processed_data/base_vectors/sift_base_{args.popularity_distribution}.tsv"
    else:
        data_path = args.data_path

    main(args.popularity_distribution, args.queries_path, selectivity_stats_path, data_path, args.output_dir, args.top_k)
