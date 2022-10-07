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
max_charge_index = abs_charge_list.index(max_charge)
max_charge = charge_list[max_charge_index]
original_charge_list = charge_list.copy()

if netcharge < 0:
    neutralizer = charge_list[max_charge_index] + abs(netcharge)
    print(f"Max charge: {max_charge} at index {max_charge_index} should be changed to {neutralizer}\n")
    charge_list[max_charge_index] = neutralizer
elif netcharge > 0:
    neutralizer = charge_list[max_charge_index] - netcharge
    print(f"Max charge: {max_charge} at index {max_charge_index} should be changed to {neutralizer}\n")
    charge_list[max_charge_index] = neutralizer
else:
    neutralizer = charge_list[max_charge_index]

sed_neutralizer = round(neutralizer, 4)
sed_oldcharge = original_charge_list[max_charge_index]
guilty_opls = df.iloc[max_charge_index, 1]
print(f"The charge for {guilty_opls} should be changed from {sed_oldcharge} to {sed_neutralizer}\n")
print(f"If you do as I say, the Final net charge will be: {sum(charge_list)}")
