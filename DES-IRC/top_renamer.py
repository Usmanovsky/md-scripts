# This copies the top file to each DES folder
from pathlib import Path
import os, shutil

def rewrite(path):    
    split_path = os.path.split(path)
#     print(split_path[1])
    return split_path[1]
    print('\n')


pathway = Path()
x = 'molx'
y = 'moly'

for folder in pathway.glob('test/*'):
    if os.path.isdir(folder):
#         print(folder)
        new_resname = rewrite(folder)
        mol_name = new_resname.split('-')
        mol_a = mol_name[0]
        mol_b = mol_name[1][0:3]
        print(mol_name)
        print(mol_a)
        print(mol_b)
#         print(new_resname)
        top_path = new_resname
        final_path = os.path.join(folder, f"{top_path}.top")
        print(final_path)
        print("\n")
        shutil.copy(f"small-sys/topology.top", final_path)
        os.system(f"sed -i 's/{x}/{mol_a}/g' {final_path}")
        os.system(f"sed -i 's/{y}/{mol_b}/g' {final_path}")