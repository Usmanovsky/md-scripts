# adapted from stat-residue.py to extract the information based on residue
# This cell gets the PLDDT from *.dat files in a directory

import sys
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import datetime

date_obj = datetime.datetime.now()

font = {
    'family': 'monospace',
    'weight': 'bold',
    'size': 12
}

plt.rcParams["figure.autolayout"] = True
plt.rc('lines', linewidth=4)
plt.rc('font', **font)

pathway = Path()
residue = []
box_dict = {}
count = 0

for file in pathway.glob("./data/amino_acid/*.csv"):
    # print(file.stem)
    residue.append(file.stem)

residue = sorted(residue)

for res in residue:
    if res=="ahelix" or res=="coil":
        continue
    
    file = pathway.glob(f"./data/amino_acid/{res}.csv").__next__()
    print(file.stem)
    # for file in pathway.glob("./data/amino_acid/*.dat"):
    # print(file.stem)
    # residue.append(file.stem)
    df=pd.read_csv(file,header=None,names=["name","PLDDT","ss"],sep ='\s+')
    df['PLDDT']=df['PLDDT'].astype(float)
    x = list(df['PLDDT'].to_numpy())
    box_dict[f"{file.stem}"] = x
    #count+=1


df_test = pd.DataFrame.from_dict(box_dict, orient='index')
df_test = df_test.transpose()
fig,ax = plt.subplots(1,1, sharey=True)
fig.set_size_inches(14, 7, forward=True)
df_test.plot(kind='box', title='Secondary structures', ax=ax)
file_name = "five_ss_"
date = date_obj.strftime("%m_%d_%Y-%H-%M")
plt.savefig(f"plots/{file_name}_{date}", facecolor="white", bbox_inches="tight", dpi=600)
plt.show()
