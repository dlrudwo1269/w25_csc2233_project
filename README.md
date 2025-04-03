# w25_csc2233_project

## Experiment Reproduction

### Data Preparation
At the root directory of the project, run
```bash
./data_prepare/data_prepare.sh
```

This will download the SIFT1M base vectors and query vectors save them in .tsv format under `/processed_data/base_vectors` and `/processed_data/queries`, respectively. We generate multiple copies of the base vectors, augmented with popularity metadata sampled from different distributions (one of Normal, Zipfian (a=2.0), Zipfian flat (a=1.1), Uniform, and Log Normal). The selectivity information for each of these distrubutions can be found under `/processed_data/selectivity_stats`.

### Experiments
To run the experiments, go to the corresponding system (chroma, postgres, VBase, elastic) and follow the `README.md` provided under the subdirectory. 
