import argparse
import csv
import os
import time
import numpy as np
from multiprocessing import Pool
from tqdm import tqdm


def read_fvecs(fvecs_path):
    """Read an fvecs file into a numpy array.
    
    The fvecs file is structured in the format <dim> <float_1> <float_2> ... <float_dim>
    for each vector.
    """
    data = np.fromfile(fvecs_path, dtype='int32')
    dim = data[0]
    return data.reshape(-1, dim + 1)[:, 1:].astype('float32')


def read_tsv_vectors(tsv_path):
    """
    Reads a TSV file of vectors in the following format:
    <vector_id (int)>\t<popularity: (float)>\t<sift_vector: ({float, float, ...})>

    Returns:
        vector_ids (list): List of vector IDs.
        popularities (np.ndarray): Popularity scores.
        numpy_vectors (np.ndarray): Corresponding vectors.
    """
    vids = []
    popularities = []
    vectors = []

    with open(tsv_path, "r", encoding="utf8") as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            if len(row) != 3:
                print("Invalid row:", row)
                continue
            
            vector_id = int(row[0])
            popularity = float(row[1])
            v = np.array(row[2][1:-1].split(", "), dtype=np.float32)

            vids.append(vector_id)
            popularities.append(popularity)
            vectors.append(v)

    return vids, np.array(popularities, dtype=np.float32), np.array(vectors, dtype=np.float32)


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


def sort_rows_by_distance(query, rows):
    """Sort rows of your dataset according to distance to the query vector."""
    vids, popularities, base_vectors = rows
    distances = np.linalg.norm(base_vectors - query, axis=1)

    # sort the rows by distance
    sorted_rows = sorted(zip(vids, popularities, base_vectors, distances), key=lambda row: row[3])
    vids = [row[0] for row in sorted_rows]
    popularities = [row[1] for row in sorted_rows]
    base_vectors = [row[2] for row in sorted_rows]
    return vids, popularities, base_vectors


def main(K, queries_path, base_vectors_path, selectivity_stats_path, output_dir):
    if not os.path.exists(queries_path):
        raise FileNotFoundError(f"File not found: {queries_path}")
    if not os.path.exists(base_vectors_path):
        raise FileNotFoundError(f"File not found: {base_vectors_path}")
    if not os.path.exists(selectivity_stats_path):
        raise FileNotFoundError(f"File not found: {selectivity_stats_path}")
    os.makedirs(output_dir, exist_ok=True)

    queries = read_fvecs(queries_path)
    rows = read_tsv_vectors(base_vectors_path)
    selectivities = read_selectivity_stats(selectivity_stats_path)

    base_file_name = os.path.basename(base_vectors_path).split(".")[0]

    for query in tqdm(queries):
        vids, popularities, _ = sort_rows_by_distance(query, rows)

        # for each selectivity, find the closest K results that satisfy the popularity threshold
        i = 0
        selectivity_to_top_k = {selectivity: [] for selectivity in selectivities.keys()}
        while (
            i < len(vids) and
            any(len(top_k_results) < K for top_k_results in selectivity_to_top_k.values())
        ):
            vid = vids[i]
            popularity = popularities[i]

            for selectivity, threshold in selectivities.items():
                if popularity <= threshold and len(selectivity_to_top_k[selectivity]) < K:
                    selectivity_to_top_k[selectivity].append(vid)

            i += 1

        # Store the results for each selectivity
        for selectivity, vids in selectivity_to_top_k.items():
            filepath = output_dir + f"/{base_file_name}_selectivity{selectivity}_gt.out"
            with open(filepath, "a", encoding="utf8") as f:
                query_str = "{" + str([float(x) for x in list(query)])[1:-1] + "}"
                f.write(f"Query: {query_str}\n")
                for vid in vids:
                    f.write(f"{vid}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--k", type=int, default=50,
        help="Number of results to retrieve for each query."
    )
    parser.add_argument(
        "--queries_path", type=str, default="raw_data/sift_query.fvecs",
        help="Path to the queries fvecs file."
    )
    parser.add_argument(
        "--base_vectors_path", type=str, help="Path to the base vectors TSV file."
    )
    parser.add_argument(
        "--selectivity_stats_path", type=str, help="Path to the selectivity stats file for the base vectors."
    )
    parser.add_argument(
        "--output_dir", type=str, default="processed_data/ground_truth",
        help="Directory to store the output ground truth files."
    )
    # NOTE: if popularity_distribution is provided, we assume this script is being
    #       used as part of the data preparation pipeline (data_prepare.sh)
    #       so we can infer the base_vectors_path and selectivity_stats_path
    parser.add_argument(
        "--popularity_distribution",
        choices=["normal", "zipfian", "uniform", "log_normal"],
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
    main(
        K=args.k,
        queries_path=args.queries_path,
        base_vectors_path=base_vectors_path,
        selectivity_stats_path=selectivity_stats_path,
        output_dir=args.output_dir
    )
    print(f"Time taken: {time.time() - start_time} seconds")
