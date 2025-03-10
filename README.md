# w25_csc2233_project

## Experiment Reproduction
### Environment Setup
TODO

### Data Preparation
At the root directory of the project, run
```bash
./data_prepare data_prepare.sh
```

This will download the SIFT1M base vectors and query vectors save them in .tsv format under `/processed_data/base_vectors` and `/processed_data/queries`, respectively. We generate multiple copies of the base vectors, augmented with popularity metadata sampled from different distributions (one of Normal, Zipfian Uniform, and Log Normal). The selectivity information for each of these distrubutions can be found under `/processed_data/selectivity_stats`.

### Evaluation
TODO
