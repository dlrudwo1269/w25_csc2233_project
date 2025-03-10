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
    return data.reshape(-1, dim + 1)[:, 1:].astype('float32')


def main(fvecs_path, output_path):
    # Sanity check paths
    if not os.path.exists(fvecs_path):
        raise FileNotFoundError(f"File not found: {fvecs_path}")
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    queries = read_fvecs(fvecs_path)
    with open(output_path, "w", encoding="utf8") as f:
        for row in queries:
            query_str = "{" + str([float(x) for x in list(row)])[1:-1] + "}"
            f.write(f"{query_str}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fvecs_path", type=str, default="raw_data/sift_query.fvecs",
        help="Path to the SIFT1M queries fvecs file"
    )
    parser.add_argument(
        "--output_path", type=str, default="processed_data/queries/sift_query.tsv",
        help="Path to store the output tsv file"
    )
    args = parser.parse_args()

    main(args.fvecs_path, args.output_path)