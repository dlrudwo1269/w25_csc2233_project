import os
import argparse
import numpy as np


def read_fvecs(fvecs_path):
    """Read an fvecs file into a numpy array.
    
    The fvecs file is structured in the format <dim> <float_1> <float_2> ... <float_dim>
    for each vector.
    """
    data = np.fromfile(fvecs_path, dtype='int32')
    dim = data[0]
    return data.reshape(-1, dim + 1)[:, 1:].copy().view('float32')


def sample_popularity(distribution, rng):
    """Sample a single instance of the popularity metadata for the given distribution."""
    if distribution == "uniform":
        return rng.uniform(0, 10000)
    elif distribution == "normal":
        return rng.normal(loc=5000, scale=1000)
    elif distribution == "zipfian":
        return rng.zipf(a=2.0)
    elif distribution == "zipfian_flat":
        return rng.zipf(a=1.1)
    elif distribution == "log_normal":
        return rng.lognormal(mean=np.log(5000), sigma=np.log(1000))
    raise ValueError(f"Unknown distribution: {distribution}")


def main(fvecs_path, output_tsv_directory, output_selectivity_stats_directory, popularity_distribution):
    # Sanity check paths
    if not os.path.exists(fvecs_path):
        raise FileNotFoundError(f"File not found: {fvecs_path}")
    if not os.path.exists(output_tsv_directory):
        os.makedirs(output_tsv_directory, exist_ok=True)
    if not os.path.exists(output_selectivity_stats_directory):
        os.makedirs(output_selectivity_stats_directory, exist_ok=True)

    # Read in data, and store vectors in tsv format with added metadata
    # Format: <vector_id (int)>\t<popularity: (float)>\t<sift_vector: ({float, float, ...})>
    data = read_fvecs(fvecs_path)
    rng = np.random.default_rng(42)
    base_filename = os.path.basename(fvecs_path).split(".")[0]
    tsv_filename = f"{base_filename}_{popularity_distribution}.tsv"
    tsv_path = output_tsv_directory + tsv_filename
    popularities = []
    with open(tsv_path, "w", encoding="utf8") as f:
        for idx, row in enumerate(data):
            vector_id = idx # just use the index as the id
            popularity = sample_popularity(popularity_distribution, rng)
            popularities.append(popularity)
            sift_vector_str = "{" + str([float(x) for x in list(row)])[1:-1] + "}"
            f.write(f"{vector_id}\t{popularity}\t{sift_vector_str}\n")

    distribution_stats_filename = f"{base_filename}_{popularity_distribution}_stats.txt"
    distribution_stats_path = output_selectivity_stats_directory + distribution_stats_filename
    with open(distribution_stats_path, "w") as f:
        f.write(f"Popularity distribution: min={popularities[0]}, max={popularities[-1]}\n")
        percentiles = [1, 10, 50, 90, 99]
        np.percentile(popularities, percentiles)
        for percentile in percentiles:
            f.write(f"Popularity {percentile}th percentile: {np.percentile(popularities, percentile)}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fvecs_path", type=str, default="raw_data/sift_base.fvecs",
        help="Path to the SIFT1M fvecs file"
    )
    parser.add_argument(
        "--output_tsv_directory", type=str, default="processed_data/base_vectors/",
        help="Directory to store the output tsv file"
    )
    parser.add_argument(
        "--output_selectivity_stats_directory", type=str, default="processed_data/selectivity_stats/",
        help="Directory to store the output selectivity stats file"
    )
    parser.add_argument(
        "--popularity_distribution",
        choices=["normal", "zipfian", "zipfian_flat", "uniform", "log_normal"],
        required=True,
        help="Distribution to sample the popularity metadata from"
    )
    args = parser.parse_args()

    main(args.fvecs_path, args.output_tsv_directory, args.output_selectivity_stats_directory, args.popularity_distribution)
