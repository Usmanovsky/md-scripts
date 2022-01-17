#!/bin/bash
"""This script merges two gro files for DES-DES simulations.
gro1 is assumed to be the box on the left and gro2 is the
box on the right so its atoms have been shifted to the right
using Gromacs gmx editconf. The new merged gro file will be 
expanded using the bigger of the x, y coordinates and the 
sum of the z coordinates (plus a 0.1nm margin in z direction)

If Dea-Men11.gro is to be merged with Thy-Lid11.gro (its contents are to be shifted),

how to run: python3 gro_merger.py Dea-Men11.gro Thy-Lid11.gro folder-path-to-save
"""

import os, sys, pandas as pd

if __name__ == "__main__":  # Accept command line inputs for gro files if script is called directly.
    try:
        if len(sys.argv[1]) > 1 and len(sys.argv[2]) > 1:
            gro1 = str(sys.argv[1])
            gro2 = str(sys.argv[2])
        else:
            print("Check your file paths. Something is wrong with them") 
        
        if len(sys.argv[3]) > 1:
            save_to = str(sys.argv[3])
        else:
            save_to = "."
    except TypeError:
        print("File paths are not correct.")
    
    


def minmax_xyz(gro):
    df = pd.read_csv(gro, sep='\s+', skiprows=[0,1], header=None)
    # df
    x = df[3]
    y = df[4]
    z = df[5]
    min_x = min(x)
    min_y = min(y)
    min_z = min(z)
    max_x = max(x)
    max_y = max(y)
    max_z = max(z)
    print(f"Minimum x y z for {gro}: \t {min_x}  {min_y}  {min_z}")
    print(f"Maximum x y z for {gro}: \t {max_x}  {max_y}  {max_z}")
    return max_x, max_y, max_z, min_x, min_y, min_z
    
    
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
    
num_atoms1, x1, y1, z1 = atomsfinder(gro1)
num_atoms2, x2, y2, z2 = atomsfinder(gro2)
total_atoms = num_atoms1 + num_atoms2

if gro1.__contains__("/"):
    gro1_name = gro1.split("/")[-1][0:-7]
else:
    gro1_name = gro1[0:-4]

if gro2.__contains__("/"):
    gro2_name = gro2.split("/")[-1][0:-7]
else:
    gro2_name = gro2[0:-4]

#merged_groname = gro1_name + "-" + gro2_name + ".gro"
# print(merged_groname)

# Grab the largest x, y, z coordinates from the molecule positions in the gro files
max_x1, max_y1, max_z1, min_x1, min_y1, min_z1 = minmax_xyz(gro1)
max_x2, max_y2, max_z2, min_x2, min_y2, min_z2 = minmax_xyz(gro2)

#  Select the largest coordinates to be used for the new merged box
new_x = max(x1, x2, max_x1, max_x2)  # New x dimension
new_y = max(y1, y2, max_y1, max_y2)  # New y dimension
#new_z = max(z1,max_z1) + max(z2, max_z2) + 0.1  # New z dimension

# Shifting zone
des = gro2_name.split('-') 
compound1 = des[0]
compound2 = des[1][0:3]
molar_ratio = des[1][3:]
distance_zshift = (max_z1 - min_z2) + 0.2  # trying to avoid too-close contact
print(compound1, compound2)
shiftedgro_name = des[0] + des[1] + ".gro"
shiftedgro = des[0] + des[1]
print(f"Shifting molecules in {gro2} by {distance_zshift} in the z-axis. Saved in {shiftedgro_name}")

try:
    os.system(f"./mol_shifter-lcc.sh {compound1} {compound2} {molar_ratio} {distance_zshift};")
except:
    print("LCC did not work. Now trying LabGPU")
    os.system(f"./mol_shifter-gpu.sh {compound1} {compound2} {molar_ratio} {distance_zshift};")

staticgro_name = gro1_name.split('-')
staticgro1 = staticgro_name[0]
staticgro2 = staticgro_name[1]
staticgro = staticgro1 + staticgro2
merged_groname = staticgro + "-" + shiftedgro_name

max_x2, max_y2, max_z2, min_x2, min_y2, min_z2 = minmax_xyz(shiftedgro_name)
new_z = max(z1,max_z1) + max(z2, max_z2) + 0.1

#  Add the first gro file to the merged box
with open(gro1, 'r') as r:
    lines = r.readlines()    
    with open(f"{save_to}/{merged_groname}",'w') as merged:        
        for line in lines:
            if line == lines[0]:
                merged.write("Usman made this on a cold night \n")
            elif line == lines[1]:
                merged.write(str(total_atoms) + "\n")
            elif line == lines[-1]:
                pass
            else:
                merged.write(line)
    

#  Add the second gro file to the merged box    
with open(shiftedgro_name, 'r') as r:
    lines = r.readlines() 
    with open(f"{save_to}/{merged_groname}",'a') as merged:
        for line in lines:
            if line == lines[0] or line == lines[1]:
                pass                
            elif line == lines[-1]:
                merged.write(f"   {new_x}   {new_y}   {new_z}")
            else:
                merged.write(line)



print(f"Success!!! {merged_groname} has {total_atoms} atoms with dimensions {new_x} {new_y} {new_z}")
#box = staticgro + shiftedgro
#os.system(f"./des_des-lcc.sh {box};")            

