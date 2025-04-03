echo "Uniform distribution" >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_99.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_uniform_99.out >> chroma_output_file.txt

echo "Log-normal distribution" >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_99.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_log_normal_99.out >> chroma_output_file.txt

echo "zipfian distribution" >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_99.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_99.out >> chroma_output_file.txt

echo "zipfian_flat distribution" >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_99.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_zipfian_flat_99.out >> chroma_output_file.txt

echo "Normal distribution" >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_1.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_10.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_50.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_90.out >> chroma_output_file.txt
python3 $PWD/result_analysis/recall.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_99.out >> chroma_output_file.txt
python3 $PWD/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/chroma_out/chroma_normal_99.out >> chroma_output_file.txt