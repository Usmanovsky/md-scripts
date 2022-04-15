"""
This script doubles the size of a GROMACS simulation box in the Z direction
and fills the space with water.
"""

import os, sys

if __name__ == "__main__":  # Accept command line inputs for gro files if script is called directly.
    try:
        if len(sys.argv[1]) > 1:
            gro = str(sys.argv[1])
        else:
            print("Check your file paths. Something is wrong with them")
    except TypeError:
        print("File paths are not correct.")


if gro.__contains__("/") and gro.__contains__("_"):
    box_name = gro.split('/')[-1].split('_')[0]
    unscaled_boxname = gro.split("/")[-1]
elif gro.__contains__("_"):
     box_name = gro.split('_')[0]
     unscaled_boxname = gro
else:
    box_name = gro[0:-4]
    unscaled_boxname = box_name + ".gro"
    
    

def atomsfinder(grofile):
    with open(grofile) as d:
        lines = d.readlines()
        if grofile.__contains__("/"):
            gro_name = grofile.split("/")[1]
        else:
            gro_name = grofile
        try:                
            num_atoms = int(lines[1].split()[0])  # get the number of atoms in the gro file
            x, y, z = [ float(numbers) for numbers in lines[-1].split() ]  # grab the box size
            print(f"{num_atoms} atoms in {gro_name} with box dimensions {x} {y} {z}")
            return num_atoms, x, y, z
        except TypeError:
                    print("oops!") 
                    
                    
box = box_name.split('-')
compoundA = box[0]
compoundB = box[1][0:3]
molar_ratio = box[1][3:]
num_atoms, x, y, z = atomsfinder(unscaled_boxname)
new_z = 2 * z
os.system(f"./gro-expander.sh {compoundA} {compoundB} {molar_ratio} {x} {y} {new_z};")

