# select n uniprots from the list
# how-to-run: python3 ./select-samples.py v4_updated_accessions.txt batch1.csv
import pandas as pd
import sys

df_in = pd.read_csv(sys.argv[1],header=None,index_col=False)

df_out = df_in.sample(n=1000000)

df_out.to_csv(sys.argv[2],index=False, header=False)

