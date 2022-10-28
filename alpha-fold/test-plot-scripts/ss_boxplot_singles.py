# adapted from stat-residue.py to extract the information based on residue
# This cell gets the PLDDT from *.dat files in a directory

import sys
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

font = {
    'family': 'monospace',
    'weight': 'bold',
    'size': 18
}

plt.rcParams["figure.autolayout"] = True
plt.rc('lines', linewidth=4)
plt.rc('font', **font)

pathway = Path()
residue = []
box_dict = {}
count = 0
# fig = plt.figure()
# fig.set_size_inches(24, 7, forward=True)
# test = fig.add_subplot(1,1,1)
# box = []

for file in pathway.glob("./data/amino_acid/*.csv"):
    # print(file.stem)
    residue.append(file.stem)

residue = sorted(residue)

for res in residue:
    file = pathway.glob(f"./data/amino_acid/{res}.csv").__next__()
    print(file.stem)
    # for file in pathway.glob("./data/amino_acid/*.dat"):
    # print(file.stem)
    # residue.append(file.stem)
    df=pd.read_csv(file,header=None,names=["name","PLDDT","ss"],sep ='\s+')
    df['PLDDT']=df['PLDDT'].astype(float)
    x = list(df['PLDDT'].to_numpy())
    # box.append(x)
    box_dict[f"{file.stem}"] = x
    count+=1

    if count==1:
        df_test = pd.DataFrame.from_dict(box_dict, orient='index')
        df_test = df_test.transpose()
        ax = df_test.plot(kind='box', title='PLDDT')
        plt.savefig(f"{file.stem}", facecolor="white", bbox_inches="tight", dpi=600)
        plt.show()
        count = 0
        box_dict = {}


# df_test = pd.DataFrame.from_dict(box_dict, orient='index')
# df_test = df_test.transpose()
# ax = df_test.plot(kind='box', title='Residues')
# plt.show()

