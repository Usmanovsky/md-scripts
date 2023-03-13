import pandas as pd 
import sys

df_db=pd.read_csv(sys.argv[1],names=["uniprot"],header=None,index_col=False)
df_ref=pd.read_csv(sys.argv[2],names=["uniprot"],header=None,index_col=False)

file_out=open(sys.argv[3],"w")

df_result=df_db[~df_db.uniprot.isin(df_ref.uniprot)]

df_result.to_csv(file_out,index=False, header=False)

