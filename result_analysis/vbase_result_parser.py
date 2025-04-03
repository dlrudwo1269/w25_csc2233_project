import re
import csv
import sys

def parse_result_file(file_path):
    """
    Parse the result file and extract the relevant metrics.
    """
    results = []
    current_distribution = None
    
    with open(file_path, 'r') as file:
        lines = file.readlines()
        
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            
            # Detect distribution type
            if line.endswith('distribution'):
                current_distribution = line.replace(' distribution', '')
                i += 1
                continue
                
            # Parse GT filename to extract selectivity
            if line.startswith('GT filename:'):
                gt_file = line.split('/')[-1]
                selectivity_match = re.search(r'_(\d+)\.out$', gt_file)
                if selectivity_match:
                    selectivity = selectivity_match.group(1)
                    
                    # Next line should be recall
                    i += 1
                    recall = float(lines[i].split(':')[1].strip()) if i < len(lines) else None
                    
                    # Next line should be vbase filename
                    i += 1
                    vbase_file = lines[i].split('/')[-1] if i < len(lines) else None
                    
                    # Next line should be vbase latency
                    i += 1
                    vbase_latency_line = lines[i] if i < len(lines) else None
                    vbase_avg, vbase_median, vbase_99th = extract_latency(vbase_latency_line)
                    
                    # Next line should be gt filename
                    i += 1
                    gt_file_line = lines[i] if i < len(lines) else None
                    
                    # Next line should be gt latency
                    i += 1
                    gt_latency_line = lines[i] if i < len(lines) else None
                    gt_avg, gt_median, gt_99th = extract_latency(gt_latency_line)
                    
                    results.append({
                        'distribution': current_distribution,
                        'selectivity': selectivity,
                        'recall': recall,
                        'vbase_avg_latency': vbase_avg,
                        'vbase_median_latency': vbase_median,
                        'vbase_99th_latency': vbase_99th,
                        'gt_avg_latency': gt_avg,
                        'gt_median_latency': gt_median,
                        'gt_99th_latency': gt_99th
                    })
            
            i += 1
            
    return results

def extract_latency(latency_line):
    """
    Extract average, median, and 99th percentile latency from a latency line.
    """
    if not latency_line or 'Latency average / median / 99th (ms):' not in latency_line:
        return None, None, None
    
    # Extract values using regex
    match = re.search(r'Latency average / median / 99th \(ms\): ([\d\.]+), ([\d\.]+), ([\d\.]+)', latency_line)
    if match:
        return float(match.group(1)), float(match.group(2)), float(match.group(3))
    return None, None, None

def write_to_csv(results, output_file):
    """
    Write the parsed results to a CSV file.
    """
    fieldnames = [
        'distribution', 'selectivity', 'recall',
        'vbase_avg_latency', 'vbase_median_latency', 'vbase_99th_latency',
        'gt_avg_latency', 'gt_median_latency', 'gt_99th_latency'
    ]
    
    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(results)
    
    print(f"Results successfully written to {output_file}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python vbase_result_parser.py <input_file> [output_file]")
        print("If output_file is not provided, 'results.csv' will be used.")
        return
    
    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "results.csv"
    
    results = parse_result_file(input_file)
    write_to_csv(results, output_file)

if __name__ == "__main__":
    main() 