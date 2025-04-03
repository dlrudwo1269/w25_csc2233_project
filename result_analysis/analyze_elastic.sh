echo "Uniform distribution" >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_uniform.tsv --path-gt $PWD/result/gt_uniform_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_99.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_uniform_99.out >> elastic_output_file.txt

echo "Log-normal distribution" >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_log_normal.tsv --path-gt $PWD/result/gt_log_normal_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_99.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_log_normal_99.out >> elastic_output_file.txt

echo "zipfian distribution" >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian.tsv --path-gt $PWD/result/gt_zipfian_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_99.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_99.out >> elastic_output_file.txt

echo "zipfian_flat distribution" >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_zipfian_flat.tsv --path-gt $PWD/result/gt_zipfian_flat_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_99.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_zipfian_flat_99.out >> elastic_output_file.txt

echo "Normal distribution" >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_1.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_1.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_10.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_10.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_50.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_50.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_90.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_90.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/recall_original.py --path-id $PWD/processed_data/base_vectors/sift_base_normal.tsv --path-gt $PWD/result/gt_normal_99.out --path-query /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_99.out >> elastic_output_file.txt
python3 $PWD/VBase/result_analysis/latency.py --path-result /scratch/expires-2025-Apr-10/kjlee/elastic_out/elastic_normal_99.out >> elastic_output_file.txt