# select n uniprots from the list
# how-to-run: python3 ./select-samples.py v4_updated_accessions.txt 1
import pandas as pd
import sys

df_in = pd.read_csv(sys.argv[1], names=['uniprot','first res','last res','AF ID', 'version'],header=None,index_col=False)

seed = int(sys.argv[2])
df_out = df_in.sample(n=1000000, random_state=seed)

df_af_id = df_out['AF ID']

full_csv = f'batch{seed}_full.csv'
df_out.to_csv(full_csv,index=False, header=False)

af_csv = f'batch{seed}.csv'
df_af_id.to_csv(af_csv,index=False, header=False)
