# extract the information based on residue
# twenty amino acid

import sys
import pandas as pd
from scipy.stats import mannwhitneyu

#residue=['ALA','ARG','ASN','ASP','CYS','GLU','GLN','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL']

residue=['ALA','ARG']

df = pd.DataFrame()

#name=sys.argv[1]
for i in range(len(residue)):
  file=residue[i]+".dat"
  df1=pd.read_csv(file,header=None,names=["name","PLDDT","ss"],sep ='\s+')
  df[residue[i]]=df1['PLDDT'].astype(float)

print(df)
print('mannwhitneyu')
# calculate the median and percentile
for i in range(len(residue)-1):
  for j in range(1,len(residue)):
    df_a=df[residue[i]].dropna()
    df_b=df[residue[j]].dropna()
    U1, p = mannwhitneyu(x=df_a,y=df_b,method="exact")
    print(residue[i],' : ',residue[j],": ","U1=", U1, " p=",p)


  
