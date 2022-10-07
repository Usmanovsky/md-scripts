# charge neutralization scratch pad
from pathlib import Path
import sys, pandas as pd

df_oplstags = []
itp = sys.argv[1]
with open(itp) as d:
    lines = d.readlines()
    for line in lines:
        stripped_line = line.strip()
        split_line = stripped_line.split()        
        if stripped_line.__contains__('opls'):
            df_oplstags.append(split_line)

df = pd.DataFrame(df_oplstags)
charges = df[6]
charge_list = []
abs_charge_list = []
netcharge = 0
for y in charges:
    charge = float(y)
    print(charge)
    charge_list.append(charge)
    netcharge += charge
    abs_charge_list.append(abs(charge))
    
    
max_charge = max(abs_charge_list)
print(f"Initial net charge: {netcharge}\n")
print(f"Max charge: {charge_list[abs_charge_list.index(max_charge)]} at index {abs_charge_list.index(max_charge)}\n")