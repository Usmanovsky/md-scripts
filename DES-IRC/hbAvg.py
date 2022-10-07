#!/bin/bash

import pandas as pd
import glob, os, re

j = [1,2]
z = [0,1]
for folder in glob.glob("hb*/*"):
    # if re.match('\d+\/', folder):
    #     name = os.path.basename(folder)
    #     print(name)
    #     path = f"*/{name}/hbond*/*hnum*.txt"
    #     bar_hnum = []
    #     norm_hnum = []
    #     bondArray = []
    #     i = 0
    # else:
    #     continue
    name = os.path.basename(folder)
    print(name)
    path = f"*/{name}/hbond*/*hnum*.txt"
    bar_hnum = []
    norm_hnum = []
    bondArray = []
    i = 0
    for txt in glob.glob(path):
        print(txt)
        bondType = os.path.basename(txt)
        print(bondType)

        if "A-A" in txt:
            bondArray.append("AA")
        elif "A-B" in txt:
            bondArray.append("AB")
        elif "B-B" in txt:
            bondArray.append("BB")
        else:
            print("Binary Interaction not Recognized!")
            bondArray.append("UNK")

        data = pd.read_csv('{}'.format(txt), sep='\s+', header=None, skiprows=[0, 1])
        data = pd.DataFrame(data)
        y = data[1].mean()
        bar_hnum.append(y)
        z = y/50
        norm_hnum.append(z)
        i = i + 1
        if i == 3:
            if txt.find("11") != -1:
                continue
            elif txt.find("12") != -1:
                norm_hnum[2] = norm_hnum[2] / 2
                norm_hnum[1] = norm_hnum[1] / 1.5
            elif txt.find("21") != -1:
                norm_hnum[0] = norm_hnum[0] / 2
                norm_hnum[1] = norm_hnum[1] / 1.5
            else:
                continue
        else:
            continue

    df = pd.DataFrame({'Bond Type': bondArray,
                       'Avg Bonds': bar_hnum})
    df.to_csv(f'{name}-hnum-avg.txt', index=False, sep="\t")

    dp = pd.DataFrame({'Bond Type': bondArray,
                       'Avg Bonds': norm_hnum})
    dp.to_csv(f'{name}-norm-hnum-avg.txt', index=False, sep="\t")

AvgPath = "./Averages"

if os.path.isdir(AvgPath):
    pass
else:
    os.mkdir("Averages")
    pass

os.system(f"mv ./*avg*.txt ./Averages")
