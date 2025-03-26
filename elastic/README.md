# Elasticsearch
## Installation
Install [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html). On the University of Toronto compute server, you can run the following:

```bash
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.4-linux-x86_64.tar.gz
tar -xzf elasticsearch-8.17.4-linux-x86_64.tar.gz
cd elasticsearch-8.17.4/
# The following line disables memory mapping. While enabling this setting is
# recommended, it requires a higher value of vm.max_map_count which we do not
# have the privileges to change on the compute server.
echo node.store.allow_mmap: false >> config/elasticsearch.yml 
```

## Run Experiment
Configure `HOME_DIR` in `run.sh` and run `elasticsearch/run.sh <distribution>`. This will start the elasticsearch server as a daemon in the background and connect to it using a Python client to index the data and save the query results to `elasticsearch/.out`.
