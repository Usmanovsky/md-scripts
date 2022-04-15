#!/bin/bash
"""
10/22/2021
In this update, I fixed a bug that gave wrong values for minmax_xyz
whenever the number of atoms grew larger than 9999 (pandas merges the
columns 2 and 3 afterwards, and shifts the rest (4,5,6...) one spot 
to the left).

This script merges two gro files for DES-DES simulations.
gro1 is assumed to be the box on the left which is  rescaled
to match gro2 in the x-y axis. gro 2 is the box on the right
so its atoms are shifted to the right using Gromacs gmx editconf.
The new merged gro file will be expanded using the bigger of the
x, y coordinates and the sum of the z coordinates (plus a 0.2nm
margin in z direction)

If Dea-Men11 is to be rescaled, while Thy-Lid11 is to be shifted to the
right, the command below will handle the process and merge both boxes
with Dea-Men11 on the left and Thy-Lid11 on the right.

python3 gro_merger_v6.py Dea-Men11_md.gro Thy-Lid11.gro folder-path-to-save
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
    


print(f"gro1: {gro1}, gro2: {gro2}")    


def minmax_xyz(gro):
    df = pd.read_csv(gro, sep='\s+', skiprows=[0,1], header=None)
    # df
    if len(df) > 9998:
        x1 = df.iloc[0:9999, 3]
        x2 = df.iloc[9999:-1,2]
        y1 = df.iloc[0:9999, 4]
        y2 = df.iloc[9999:-1,3]
        z1 = df.iloc[0:9999, 5]
        z2 = df.iloc[9999:-1,4]
        x = pd.concat([x1,x2], axis=0)
        y = pd.concat([y1,y2], axis=0)
        z = pd.concat([z1,z2], axis=0)        
    else:
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

if gro1.__contains__("/") and gro1.__contains__("_md"):
    gro1_name = gro1.split("/")[-1][0:-7]
    unscaled_groname = gro1.split("/")[-1]
elif gro1.__contains__("_md"):
     gro1_name = gro1[0:-7]
     unscaled_groname = gro1
else:
    gro1_name = gro1[0:-4]
    unscaled_groname = gro1_name + ".gro"

if gro2.__contains__("/") and gro2.__contains__("_md"):
    gro2_name = gro2.split("/")[-1][0:-7]
elif gro2.__contains__("_md"):
     gro2_name = gro2[0:-7]
else:
    gro2_name = gro2[0:-4]



print(f"gro1_name: {gro1_name}, gro2_name: {gro2_name}, unscaled_groname: {unscaled_groname}")

#rescaling zone
#print(unscaled_groname)
x_rescale = x2/x1
y_rescale = y2/y1
des_rescale = gro1_name.split('-')
compoundA = des_rescale[0]
compoundB = des_rescale[1][0:3]
molar_ratio = des_rescale[1][3:]
print(compoundA, compoundB)
rescaled_gro1_name = gro1_name + ".gro"
print(rescaled_gro1_name)
print(f"Rescaling {gro1} by {x_rescale} and {y_rescale} in the x and y-axis. To be saved in {rescaled_gro1_name}")

try:
    os.system(f"./box_rescaler-lcc.sh {compoundA} {compoundB} {molar_ratio} {x_rescale} {y_rescale};")
except:
    print("LCC box_rescaling did not work. Now trying LabGPU")
    os.system(f"./box_rescaler-gpu.sh {compoundA} {compoundB} {molar_ratio} {x_rescale} {y_rescale};")
#merged_groname = gro1_name + "-" + gro2_name + ".gro"
# print(merged_groname)

# Grab the largest x, y, z coordinates from the molecule positions in the gro files
max_x1, max_y1, max_z1, min_x1, min_y1, min_z1 = minmax_xyz(rescaled_gro1_name)
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
    os.system(f"./mol_shifter-lcc.sh {compound1} {compound2} {molar_ratio} {distance_zshift} {gro2_name};")
except:
    print("LCC did not work. Now trying LabGPU")
    os.system(f"./mol_shifter-gpu.sh {compound1} {compound2} {molar_ratio} {distance_zshift} {gro2_name};")

staticgro_name = gro1_name.split('-')
staticgro1 = staticgro_name[0]
staticgro2 = staticgro_name[1]
staticgro = staticgro1 + staticgro2
merged_groname = staticgro + "-" + shiftedgro_name

max_x2, max_y2, max_z2, min_x2, min_y2, min_z2 = minmax_xyz(shiftedgro_name)
new_z = max(z2, max_z2) + 0.1

#  Add the first gro file to the merged box
#gro1 = gro1_name + ".gro"
with open(rescaled_gro1_name, 'r') as r:
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

