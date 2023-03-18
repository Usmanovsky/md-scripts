#!/bin/bash

# This script loops through all the DES folders in the working directory
# and submits the simulation job.

from pathlib import Path
import os, sys

pathway = Path()
path = str(sys.argv[1])

for file in pathway.glob(path):
    if os.path.isdir(file):
        des = file.stem.split('-')        
        folder = os.path.normpath(file)
        print(folder)
        compound1 = des[0]
        compound2 = des[1][0:3]
        molar_ratio = des[1][3:]
        print(compound1, compound2)
        os.system(f"cd '{file}'; ls; ./hbond_cc.sh {compound1} {compound2} {molar_ratio};")
        print("\n")
