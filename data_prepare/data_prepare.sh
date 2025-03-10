#!/bin/bash

# 1. Download SIFT1M vectors and queries
mkdir -p raw_data
wget -nc -P raw_data https://huggingface.co/datasets/qbo-odp/sift1m/resolve/main/sift_base.fvecs
wget -nc -P raw_data https://huggingface.co/datasets/qbo-odp/sift1m/resolve/main/sift_query.fvecs

# 2. Convert base vector fvec files to tsv format with added popularity metadata
mkdir -p processed_data
mkdir -p processed_data/base_vectors
distributions=("normal" "zipfian" "uniform" "log_normal")
for dist in "${distributions[@]}"; do
    echo "Processing $dist distribution"
    python data_prepare/convert_fvecs_base_vectors.py --popularity_distribution "$dist"
done

# 3. Convert queries fvecs file to tsv file
python data_prepare/convert_fvecs_queries.py