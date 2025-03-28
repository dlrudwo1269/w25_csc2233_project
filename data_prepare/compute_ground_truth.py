import argparse
import csv
import os
import time
import numpy as np
from tqdm import tqdm


def load_queries(queries_path):
    queries = []
    with open(queries_path, 'r', encoding="utf8") as f:
        for query in f:
            query = query.strip().strip("{}")
            queries.append(np.array(query.split(", "), dtype=np.float32))
    return queries


def read_tsv_vectors(tsv_path):
    ids, embeddings, popularities = [], [], []
    with open(tsv_path, 'r', encoding="utf8") as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            if len(row) != 3:
                print(f"Invalid row {row}")
                continue
            ids.append(int(row[0]))
            popularities.append(float(row[1]))
            embeddings.append(np.array(row[2][1:-1].split(", "), dtype=np.float32))
    return np.array(ids), np.array(popularities, dtype=np.float32), np.vstack(embeddings)


def read_selectivity_stats(stats_path):
    selectivities = {}
    with open(stats_path, "r", encoding="utf8") as f:
        for line in f.readlines()[1:]:  # Skip first line
            words = line.split(" ")
            selectivity = int(words[1].removesuffix("th"))
            selectivities[selectivity] = float(words[-1])
    assert set(int(s) for s in selectivities.keys()) == {1, 10, 50, 90, 99}
    return selectivities


def sort_rows_by_ip(query, rows):
    vids, popularities, base_vectors = rows
    similarities = np.dot(base_vectors, query)
    assert similarities.shape == (len(vids),), "Shape of similarities does not match number of rows."
    
    # Sort rows by descending similarity (higher inner product means closer)
    sorted_rows = sorted(zip(vids, popularities, base_vectors, similarities), key=lambda row: row[3], reverse=True)
    vids = [row[0] for row in sorted_rows]
    popularities = [row[1] for row in sorted_rows]
    base_vectors = [row[2] for row in sorted_rows]
    
    return np.array(vids), np.array(popularities), base_vectors


def compute_ground_truth(K, queries, rows, selectivities, output_dir, base_filename):
    for query in tqdm(queries):
        vids, popularities, _ = sort_rows_by_ip(query, rows)
        
        selectivity_to_top_k = {}
        for selectivity, threshold in selectivities.items():
            mask = popularities <= threshold
            selectivity_to_top_k[selectivity] = vids[mask][:K].tolist()

        for selectivity, results in selectivity_to_top_k.items():
            filepath = os.path.join(output_dir, f"{base_filename}_selectivity{selectivity}.gt")
            with open(filepath, "a", encoding="utf8") as f:
                f.write("Timing is on.\n")
                f.write("id\n") 
                f.write("-----------\n")
                for vid in results:
                    f.write(f"{vid:>10}\n")
                f.write(f"({len(results)} rows)\n\n")
                f.write(f"Time: 0 ms\n")
                f.write("Timing is off.\n")


def main(K, queries_path, base_vectors_path, selectivity_stats_path, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    
    queries = load_queries(queries_path)
    rows = read_tsv_vectors(base_vectors_path)
    selectivities = read_selectivity_stats(selectivity_stats_path)
    base_filename = os.path.basename(base_vectors_path).split(".")[0]
    
    compute_ground_truth(K, queries, rows, selectivities, output_dir, base_filename)
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--k", type=int, default=50)
    parser.add_argument("--queries_path", type=str, default="processed_data/queries/sift_query.tsv")
    parser.add_argument("--base_vectors_path", type=str)
    parser.add_argument("--selectivity_stats_path", type=str)
    parser.add_argument("--output_dir", type=str, default="processed_data/ground_truth")
    parser.add_argument(
        "--popularity_distribution",
        choices=["normal", "zipfian", "zipfian_flat", "uniform", "log_normal"],
        help="Distribution to sample the popularity metadata from"
    )
    args = parser.parse_args()

    if (
        not args.popularity_distribution and
        (not args.base_vectors_path and not args.selectivity_stats_path)
    ):
        raise ValueError("Please provide either a popularity distribution or paths to base vectors and selectivity stats.")
    elif args.popularity_distribution:
        base_vectors_path = f"processed_data/base_vectors/sift_base_{args.popularity_distribution}.tsv"
        selectivity_stats_path = f"processed_data/selectivity_stats/sift_base_{args.popularity_distribution}_stats.txt"
    else:
        base_vectors_path = args.base_vectors_path
        selectivity_stats_path = args.selectivity_stats_path

    start_time = time.time()
    main(args.k, args.queries_path, base_vectors_path, selectivity_stats_path, args.output_dir)
    print(f"Time taken: {time.time() - start_time:.2f} seconds")