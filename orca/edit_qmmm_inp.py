# created by ulab
import sys, os
from pathlib import Path

pathway = Path()

'''
This script calls edit_qmmm_inp.sh to create an inp file for QM/QM2 calculations.
The first argument is the directory that contains the active xyz files.
The second argument is the directory that contains the full xyz files.
The third argument is the name of the inp file that will be created.

how to run: python3 edit_qmmm_inp.py ../../actives-5 ../../full-structure 6jxt
'''

import itertools

def ranges(i):
    for a, b in itertools.groupby(enumerate(i), lambda pair: pair[1] - pair[0]):
        b = list(b)
        yield b[0][1], b[-1][1]


active_path = sys.argv[1]  # folder containing active xyz files
full_path = sys.argv[2]  # folder containing full xyz files
pdb_tag = sys.argv[3]
# active_id = []
# active_id_in_full_xyz = []

for xyz in pathway.glob(f'{active_path}/{pdb_tag}*.xyz'):
    active_file = xyz
    full_xyz = xyz.stem.upper()
    full_file = f'{full_path}/{full_xyz}-quickprepped.xyz'
    print(full_xyz)
    active_id = []
    active_id_in_full_xyz = []
    with open(full_file, 'r+') as full:  # open the full structure
        full_list = full.readlines()
        # print(full_list[-1])  
        with open(active_file, 'r+') as active:  # open the active structure        
            for l_no, line in enumerate(active):
                if line.strip() and line in full_list:
                    # print(l_no, line)  # the active atom in the full xyz structure
                    active_in_full_id = full_list.index(line) - 2
                    # print(active_in_full_id)
                    active_id.append(l_no)
                    active_id_in_full_xyz.append(active_in_full_id)
                    # print('\n')            
                #     break

    active_indices_string = f"\"{list(ranges(active_id_in_full_xyz))}\""
    active_indices_string_inp = active_indices_string.replace("[", "").replace("]", "").replace("),", "").replace("(", "").replace(")","").replace(", ", ":")
    print(active_indices_string)
    print(active_indices_string_inp)
    
    #xyz_input = f"\"{active_id_in_full_xyz}\""
    #xyz_input = xyz_input.replace("[", "").replace("]", "").replace(",", "")
    #print(xyz_input)

    if os.path.isfile(f"./{xyz.stem}.inp"):
        print(f'{xyz.stem}.inp already exists. SKipping the creation step...')
    else:
        os.system(f"cp ~/myscripts/orca/template_qmmm.inp ./{xyz.stem}.inp")

    os.system(f"~/myscripts/orca/edit_qmmm_inp.sh {xyz.stem}.inp {xyz.stem} {active_indices_string_inp}")
