
import csv
import argparse

POPULARITY_FILTER = 100 # TODO: not sure what to do

def query_generate(path_emb, path_or):
    outputfile="./sql/query.sql"
    
    with open(path_emb, 'r', encoding="utf8") as f_emb, \
         open(outputfile,'w',encoding="utf8") as out:
        tsv_emb = csv.reader(f_emb, delimiter="\t")
        idx = 0
        out.write("\\c test_db;\n\n")
        out.write("create index if not exists bindex on sift_table(popularity);\n");
        out.write("set enable_seqscan=off;\n")
        out.write("set enable_indexscan=on;\n")
        for (id, embedding) in tsv_emb:
            embedding=embedding[1:-1]
            
            out.write("\\timing on\n")
            out.write(f"select id from sift_table where (popularity<={POPULARITY_FILTER}) order by sift_vector<*>ARRAY[{embedding}] limit 50;\n")
            out.write("\\timing off\n")
            idx += 1
            if idx%1000 == 0:
                print(f"{idx} document embeddings saved...")
            if idx==10000:
                break

if  __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--path-emb', type=str, default="processed_data/base_vectors/sift_base_<distribution-name>.tsv", help='path to image embedding query')

    args = parser.parse_args()

    query_generate(args.path_emb)
