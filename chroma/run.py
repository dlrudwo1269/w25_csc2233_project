import argparse
import csv
import os
import time
import chromadb


SELECTIVITIES = [1, 10, 50, 90, 99]


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


def load_base_vectors(data_path):
    ids = []
    embeddings = []
    popularities = []
    with open(data_path, 'r', encoding="utf8") as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            ids.append(row[0])
            popularities.append({"popularity": float(row[1])})
            embedding = row[2][1:-1] # remove enclosing { and }
            embeddings.append([float(x) for x in embedding.split(",")])

    return ids, embeddings, popularities


def load_queries(queries_path):
    queries = []
    with open(queries_path, 'r', encoding="utf8") as f:
        for query in f:
            query = query.strip().strip("{}")
            queries.append([float(x) for x in query.split(", ")])
    return queries


def setup_chromadb_collection(collection_name, ids, embeddings, popularities):
    chroma_client = chromadb.Client()

    print(f"Creating collection {collection_name}...")
    # Create ephemeral chroma client
    collection = chroma_client.get_or_create_collection(
        name=collection_name,
        metadata={
            "hnsw:space": "ip",
            "hnsw:construction_ef": 200,
            "hnsw:search_ef": 64,
            "hnsw:M": 16,
            "hnsw:num_threads": 32,
        }
    )

    num_vectors = len(ids)
    print(f"Indexing {num_vectors} embeddings...")
    batch_size = 40000 # this is a value that works empirically without exceeding batch limit
    for i in range(0, num_vectors, batch_size):
        collection.add(
            ids=ids[i:i+batch_size],
            embeddings=embeddings[i:i+batch_size],
            metadatas=popularities[i:i+batch_size],
        )
        if collection.count() % (40000 * 5) == 0:
            print(f"Indexed {collection.count()} items in collection.")
    print(f"Done indexing. {collection.count()} items in collection.")
    return collection


def run_queries(queries, collection, popularity_threshold, top_k, selectivity):
    """
    For each query, fetch an expanded candidate set (top_k multiplied by 100/selectivity),
    then post-filter the results based on the popularity threshold.
    """
    all_results = []
    errors = 0
    # Compute multiplier: if selectivity is 1 (i.e. 1%), then fetch 100 * top_k results.
    multiplier = 100 / selectivity
    fetch_count = int(multiplier * top_k)
    
    for query in queries:
        if len(all_results) % 100 == 0:
            print(f"Processed {len(all_results)} queries")
        try:
            start_time = time.time()
            # Query without pre-filtering; include metadatas to post-filter.
            query_response = collection.query(
                query_embeddings=[query],
                n_results=fetch_count,
                include=["metadatas"],
            )
            # We only have a single query vector, so we need to index out the (only) result from the nested list
            candidate_ids = query_response["ids"][0]
            candidate_metadatas = query_response["metadatas"][0]
            # Post-filter based on the popularity threshold.
            filtered_ids = []
            for cid, metadata in zip(candidate_ids, candidate_metadatas):
                if metadata["popularity"] <= popularity_threshold:
                    filtered_ids.append(cid)
                if len(filtered_ids) == top_k:
                    break
            end_time = time.time()
            latency = (end_time - start_time) * 1000  # convert to ms
            # If not enough results were found, pad with -1.
            if len(filtered_ids) < top_k:
                filtered_ids.extend([-1] * (top_k - len(filtered_ids)))
        except RuntimeError:
            errors += 1
            filtered_ids = [-1] * top_k
            end_time = time.time()
            latency = (end_time - start_time) * 1000
        all_results.append((filtered_ids, latency))
    
    if errors:
        print(f"{errors} errors on collection {collection.name} with threshold {popularity_threshold}")
    return all_results


def main(popularity_distribution, queries_path, selectivity_stats_path, data_path, output_dir, top_k):
    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Load data
    ids, embeddings, popularities = load_base_vectors(data_path)
    queries = load_queries(queries_path)
    selectivity_stats = read_selectivity_stats(selectivity_stats_path)

    # Setup ChromaDB
    collection_name = f"sift1m_{popularity_distribution}"
    collection = setup_chromadb_collection(collection_name, ids, embeddings, popularities)

    # Run queries
    for selectivity in SELECTIVITIES:
        popularity_threshold = selectivity_stats[selectivity]
        results = run_queries(queries, collection, popularity_threshold, top_k, selectivity)

        # Log results
        filename = f"chroma_{popularity_distribution}_{selectivity}.out"
        with open(os.path.join(output_dir, filename), "w", encoding="utf8") as out:
            for top_k_vectors, latency in results:
                # Match format of VBase eval pipeline
                out.write("Timing is on.\n")
                out.write("vector_id\n") 
                out.write("-----------\n")
                for vid in top_k_vectors:
                    out.write(f"{vid:>10}\n") # right-justify with width of 10
                out.write(f"({len(top_k_vectors)} rows)\n\n")
                out.write(f"Time: {latency} ms\n")
                out.write("Timing is off.\n")


if __name__ == "__main__":
    # Usage: python chroma/run.py --popularity_distribution [DISTRIBUTION] --output_dir ./chroma/.out
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
