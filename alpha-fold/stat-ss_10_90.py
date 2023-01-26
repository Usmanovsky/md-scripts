# extract the information based on residue
# twenty amino acid
# Replaced min and max with 10th and 90th percentiles

import sys
import pandas as pd

#residue=['ALA','ARG','ASN','ASP','CYS','GLU','GLN','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL']

name=sys.argv[1]
file=name+".csv"

df=pd.read_csv(file,header=None,names=["name","PLDDT","ss"],sep ='\s+')
df['PLDDT']=df['PLDDT'].astype(float)

# calculate the median and percentile
DDT_min=df['PLDDT'].quantile(0.10)
DDT_max=df['PLDDT'].quantile(0.90)
DDT_median=df['PLDDT'].median()
DDT_std=df['PLDDT'].std()
DDT_75=df['PLDDT'].quantile(0.75)
DDT_25=df['PLDDT'].quantile(0.25)

print(name)
print('median: ', DDT_median)
print('min: ', DDT_min)
print('max: ', DDT_max)
print('75 percentile: ', DDT_75)
print('25 percentile: ', DDT_25)


  
