import argparse
import os

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


def query_generate(queries_path, selectivity, selectivity_stats_path, output_path, top_k):
    # sanity check output path
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    selectivity_stats = read_selectivity_stats(selectivity_stats_path)
    assert selectivity in selectivity_stats
    popularity_threshold = selectivity_stats[selectivity]

    with open(queries_path, 'r', encoding="utf8") as f_emb, \
         open(output_path,'w',encoding="utf8") as out:
        idx = 0
        out.write("\\c vectordb;\n\n")
        out.write("create index if not exists bindex on sift_table(popularity);\n");
        out.write("set enable_seqscan=off;\n")
        out.write("set enable_indexscan=on;\n")

        for embedding in f_emb:
            # Clean and properly format the embedding
            embedding = embedding.strip()
            
            # Remove enclosing brackets if present
            if embedding.startswith('{') and embedding.endswith('}'):
                embedding = embedding[1:-1]
            elif embedding.startswith('[') and embedding.endswith(']'):
                embedding = embedding[1:-1]
                
            # Split the embedding into individual values
            try:
                # Try to split by comma
                values = [float(val.strip()) for val in embedding.split(',') if val.strip()]
                
                # If that doesn't work, try splitting by space
                if len(values) <= 1 and ' ' in embedding:
                    values = [float(val.strip()) for val in embedding.split() if val.strip()]
                
                # Format the array properly for PostgreSQL
                formatted_embedding = "ARRAY[" + ", ".join(str(val) for val in values) + "]"
                
                out.write("\\timing on\n")
                out.write(f"select vector_id from sift_table where (popularity<={popularity_threshold}) order by sift_vector<*>{formatted_embedding} limit {top_k};\n")
                out.write("\\timing off\n")
                idx += 1
                if idx%1000 == 0:
                    print(f"{idx} document embeddings saved...")
                if idx==10000:
                    break
            except Exception as e:
                print(f"Warning: Could not parse embedding: {embedding[:30]}... - {str(e)}")
                continue


if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--selectivity",
        choices=[1, 10, 50, 90, 99, 100],
        type=int,
        required=True,
        help="The selectivity threshold for popularity filter"
    )
    parser.add_argument(
        "--popularity_distribution",
        choices=["normal", "zipfian", "uniform", "log_normal", "zipfian_flat"],
        help="Distribution over which the popularity metadata is sampled"
    )
    parser.add_argument(
        "--selectivity_stats_path", type=str, help="Path to the selectivity stats file"
    )
    parser.add_argument(
        "--queries_path", type=str, default="processed_data/queries/sift_query.tsv",
        help="Path to the queries fvecs file."
    )
    parser.add_argument(
        "--output_path", type=str, help="Path to store results"
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

    if not args.popularity_distribution and not args.output_path:
        raise ValueError("Please provide either a popularity distribution or the output file name.")
    elif args.popularity_distribution and not args.output_path:
        output_path = f"./sql/{args.popularity_distribution}_threshold{args.selectivity}_query.sql"
    else:
        output_path = args.output_path

    query_generate(args.queries_path, args.selectivity, selectivity_stats_path, output_path, args.top_k)
