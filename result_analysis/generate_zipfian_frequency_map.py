import numpy as np
import argparse
import os
from collections import Counter

def generate_frequency_map_from_tsv(tsv_file, output_file):
    """Generate a frequency map from a TSV file containing popularity data.
    
    Args:
        tsv_file: Path to the TSV file containing popularity data
        output_file: Path to save the frequency map
    """
    # Read popularity values from TSV file
    popularities = []
    with open(tsv_file, 'r') as f:
        for line in f:
            # Split by tab and get the popularity value (second column)
            popularity = float(line.strip().split('\t')[1])
            popularities.append(popularity)
    
    # Count frequencies
    frequency_map = Counter(popularities)
    
    # Sort by frequency in descending order
    sorted_frequencies = sorted(frequency_map.items(), key=lambda x: x[1], reverse=True)
    
    # Write to file
    with open(output_file, 'w') as f:
        f.write("Value,Frequency\n")
        for value, freq in sorted_frequencies:
            f.write(f"{value},{freq}\n")
    
    # Print some statistics
    print(f"\nStatistics for {os.path.basename(tsv_file)}:")
    print(f"Total samples: {len(popularities)}")
    print(f"Total unique values: {len(frequency_map)}")
    print(f"Most common value: {sorted_frequencies[0][0]} (frequency: {sorted_frequencies[0][1]})")
    print(f"Least common value: {sorted_frequencies[-1][0]} (frequency: {sorted_frequencies[-1][1]})")
    print(f"Mean popularity: {np.mean(popularities):.2f}")
    print(f"Median popularity: {np.median(popularities):.2f}")
    print(f"Std popularity: {np.std(popularities):.2f}")

def main():
    parser = argparse.ArgumentParser(description='Generate frequency maps from TSV files')
    parser.add_argument('--tsv_dir', type=str, default='processed_data/base_vectors',
                      help='Directory containing the TSV files')
    parser.add_argument('--output_dir', type=str, default='processed_data/frequency_maps',
                      help='Directory to save the frequency maps')
    args = parser.parse_args()

    # Create output directory if it doesn't exist
    os.makedirs(args.output_dir, exist_ok=True)

    # Process zipfian distribution
    zipfian_tsv = os.path.join(args.tsv_dir, 'sift_base_zipfian.tsv')
    if os.path.exists(zipfian_tsv):
        print("\nGenerating frequency map for zipfian distribution...")
        generate_frequency_map_from_tsv(
            zipfian_tsv,
            os.path.join(args.output_dir, 'zipfian_frequency_map.csv')
        )
    else:
        print(f"Warning: {zipfian_tsv} not found")

    # Process zipfian_flat distribution
    zipfian_flat_tsv = os.path.join(args.tsv_dir, 'sift_base_zipfian_flat.tsv')
    if os.path.exists(zipfian_flat_tsv):
        print("\nGenerating frequency map for zipfian_flat distribution...")
        generate_frequency_map_from_tsv(
            zipfian_flat_tsv,
            os.path.join(args.output_dir, 'zipfian_flat_frequency_map.csv')
        )
    else:
        print(f"Warning: {zipfian_flat_tsv} not found")

if __name__ == "__main__":
    main()
