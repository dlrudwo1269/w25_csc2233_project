import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read data into a DataFrame
# df = pd.read_csv("chroma_output.csv")
# df = pd.read_csv("elastic_results.csv")
df = pd.read_csv("results.csv")

# Get unique selectivity values
selectivity_values = df['selectivity'].unique()
selectivity_values.sort()  # Ensure they're in order

# Get unique distributions
distributions = df['distribution'].unique()
num_distributions = len(distributions)

# Create the figure with subplots
fig, axes = plt.subplots(1, len(selectivity_values), figsize=(20, 8), sharey=True)

# Define a color map for distributions
colors = plt.cm.tab10(np.linspace(0, 1, num_distributions))

# Define bar positions
latency_types = ['Average', 'Median', '99th Percentile']
x = np.arange(len(latency_types))
width = 0.15  # Narrower width to fit all distributions

# Loop through each selectivity value
for i, selectivity in enumerate(selectivity_values):
    ax = axes[i]
    
    # Filter data for this selectivity
    df_filtered = df[df['selectivity'] == selectivity]
    
    # Plot bars for each distribution
    for j, dist in enumerate(distributions):
        dist_data = df_filtered[df_filtered['distribution'] == dist]
        
        if not dist_data.empty:
            # Calculate position offset for this distribution
            pos_offset = width * (j - num_distributions/2 + 0.5)
            
            # Extract the three latency values for this distribution
            avg = dist_data['elastic_avg_latency'].values[0]
            median = dist_data['elastic_median_latency'].values[0]
            p99 = dist_data['elastic_99th_latency'].values[0]
            
            # Plot the bars at their respective positions
            ax.bar(x[0] + pos_offset, avg, width, color=colors[j], label=dist if i == 0 else "")
            ax.bar(x[1] + pos_offset, median, width, color=colors[j])
            ax.bar(x[2] + pos_offset, p99, width, color=colors[j])
    
    # Customize the subplot
    ax.set_xticks(x)
    ax.set_xticklabels(latency_types)
    ax.set_title(f'Selectivity = {selectivity}')
    
    # Only set y-axis label for the first subplot
    if i == 0:
        ax.set_ylabel('Latency (ms)')
    
    # Set y-scale to log for all plots
    ax.set_yscale('log')

# Add a common legend at the top of the figure
fig.legend(loc='upper center', bbox_to_anchor=(0.5, 0.98), ncol=num_distributions)

# Adjust layout
plt.tight_layout()
plt.subplots_adjust(top=0.85, wspace=0.1)  # Increase top margin, reduce space between subplots

# Save the plot
# plt.savefig("chroma_1.png", dpi=300, bbox_inches='tight')
plt.savefig("vbase_1.png", dpi=300, bbox_inches='tight')

plt.close()