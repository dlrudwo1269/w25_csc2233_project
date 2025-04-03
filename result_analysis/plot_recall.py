import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read data into a DataFrame
df = pd.read_csv("results.csv")

# Get unique selectivity values and distributions
selectivity_values = sorted(df['selectivity'].unique())
distributions = df['distribution'].unique()

# Set up the figure and axis
plt.figure(figsize=(12, 7))

# Calculate bar width and positions
n_bars = len(distributions)
total_width = 0.8  # Width allocated for all bars at one x position
bar_width = total_width / n_bars  # Individual bar width
offset = np.arange(len(selectivity_values))  # X positions for groups

# Create colormap
colors = plt.cm.tab10(np.linspace(0, 1, len(distributions)))

# Plot bars for each distribution
for i, dist in enumerate(distributions):
    # Filter data for this distribution
    dist_data = df[df['distribution'] == dist]
    
    # Get recall values for each selectivity
    recall_values = []
    for selectivity in selectivity_values:
        recall = dist_data[dist_data['selectivity'] == selectivity]['recall'].values
        # Ensure recall values never exceed 1.0 (in case of any data errors)
        recall_value = min(recall[0] if len(recall) > 0 else 0, 1.0)
        recall_values.append(recall_value)
    
    # Calculate position for this set of bars
    pos = offset - total_width/2 + (i + 0.5) * bar_width
    
    # Plot the bars
    bars = plt.bar(pos, recall_values, width=bar_width, label=dist, color=colors[i])
    
    # Add value labels on top of each bar
    for j, bar in enumerate(bars):
        height = bar.get_height()
        # Position the text just below 1.0 if the bar is very close to 1.0
        text_y_pos = min(height + 0.0005, 0.998)
        plt.text(bar.get_x() + bar.get_width()/2, text_y_pos,
                f'{height:.4f}', ha='center', va='bottom', rotation=90, fontsize=7)

# Set axis labels and title
plt.xlabel('Selectivity')
plt.ylabel('Recall')

# Set x-tick labels to selectivity values
plt.xticks(offset, [str(s) for s in selectivity_values])

# Set y-axis limits - minimum based on data, maximum exactly 1.0
min_recall = max(0.8, df['recall'].min() * 0.995)  # Don't go too low
plt.ylim(min_recall, 1.0)

# Add grid lines for better readability
plt.grid(axis='y', linestyle='--', alpha=0.7)

# Add legend in the upper right corner
plt.legend(title='Distribution', loc='upper right', frameon=True)

# Improve layout
plt.tight_layout()

# Save the plot
plt.savefig("./plots/vbase_recall.png", dpi=600, bbox_inches='tight')
plt.close()
