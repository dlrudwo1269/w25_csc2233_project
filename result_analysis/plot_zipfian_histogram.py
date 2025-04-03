import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os

def plot_zipfian_histogram(csv_file, output_file=None, a=4.0, size=20000):
    """
    Plot a histogram of the zipfian distribution with both sample and expected counts.
    Using log scales on both axes to show the full distribution.
    
    Args:
        csv_file: Path to the CSV file containing value,frequency pairs
        output_file: Path to save the plot (if None, display instead)
        a: Alpha parameter for the zipfian distribution
        size: Total number of samples
    """
    # Read the data
    df = pd.read_csv(csv_file)
    
    # Get all unique values and their frequencies
    values = df['Value'].values
    frequencies = df['Frequency'].values
    
    # Calculate expected counts for all values
    # For Zipf distribution, P(X = k) = 1/(k^a * zeta(a))
    from scipy.special import zeta
    expected_counts = size * (1 / (values ** a)) / zeta(a)
    
    # Create the plot
    plt.figure(figsize=(15, 10))
    
    # Set font sizes
    plt.rcParams['font.size'] = 24
    plt.rcParams['axes.labelsize'] = 28
    plt.rcParams['axes.titlesize'] = 28
    plt.rcParams['xtick.labelsize'] = 24
    plt.rcParams['ytick.labelsize'] = 24
    plt.rcParams['legend.fontsize'] = 24
    
    # Calculate bar widths that look good on log scale
    # Make them smaller for small values and larger for large values
    log_values = np.log10(values)
    widths = np.where(values < 10, 0.2, values * 0.05)
    
    # Plot bars for sample counts
    plt.bar(values, frequencies, alpha=0.5, color='skyblue', label='sample count', width=widths)
    
    # Plot line for expected counts
    plt.plot(values, expected_counts, 'ko-', label='expected count', markersize=2, alpha=0.5)
    
    # Calculate percentiles taking frequencies into account
    percentiles = [1, 10, 50, 90, 99]
    # Repeat each value according to its frequency
    weighted_values = np.repeat(values, frequencies)
    percentile_values = np.percentile(weighted_values, percentiles)
    
    # Add vertical lines for percentiles
    colors = ['red', 'orange', 'green', 'blue', 'purple']
    for p, v, c in zip(percentiles, percentile_values, colors):
        plt.axvline(x=v, color=c, linestyle='--', alpha=0.5, linewidth=2)
        plt.text(v, plt.ylim()[1], f'{p}th', rotation=90, verticalalignment='top', color=c, fontsize=34)
    
    # Set log scale for both axes
    plt.xscale('log', base=10)  # Use base-2 for x-axis to reduce gaps
    plt.yscale('log', base=10)
    
    # Customize the plot
    plt.grid(True, which="both", ls="-", alpha=0.2)
    plt.xlabel('Value')
    plt.ylabel('Count')
    plt.legend()
    
    # Set reasonable axis limits
    plt.xlim(0.9, max(values)*1.1)
    plt.ylim(0.9, max(frequencies)*1.1)
    
    # Add minor gridlines
    plt.grid(True, which='minor', ls=':', alpha=0.1)
    
    # Adjust layout
    plt.tight_layout()
    
    # Save or show the plot
    if output_file:
        plt.savefig(output_file, dpi=300, bbox_inches='tight')
        print(f"Plot saved to {output_file}")
    else:
        plt.show()
    
    # Print some statistics
    print(f"\nStatistics for {os.path.basename(csv_file)}:")
    print(f"Total samples: {sum(frequencies)}")
    print(f"Unique values: {len(values)}")
    print(f"Min value: {min(values)}")
    print(f"Max value: {max(values)}")
    print(f"Most frequent value: {values[0]} (frequency: {frequencies[0]})")
    print(f"Least frequent value: {values[-1]} (frequency: {frequencies[-1]})")
    print("\nPercentile Statistics (weighted by frequency):")
    for p, v in zip(percentiles, percentile_values):
        print(f"{p}th percentile: {v:.2f}")

if __name__ == "__main__":
    # Create output directory if it doesn't exist
    output_dir = "plots"
    os.makedirs(output_dir, exist_ok=True)
    
    # Plot for regular zipfian
    plot_zipfian_histogram(
        'processed_data/frequency_maps/zipfian_frequency_map.csv',
        os.path.join(output_dir, 'zipfian_histogram_full.png'),
        a=2.0,  # The a parameter used in the original data generation
        size=1000000  # The total number of samples in your data
    )
    
    # Plot for zipfian flat
    plot_zipfian_histogram(
        'processed_data/frequency_maps/zipfian_flat_frequency_map.csv',
        os.path.join(output_dir, 'zipfian_flat_histogram_full.png'),
        a=1.1,  # The a parameter used in the original data generation
        size=1000000  # The total number of samples in your data
    ) 