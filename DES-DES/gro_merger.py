"""This script merges two gro files for DES-DES simulations.
gro1 is assumed to be the box on the left and gro 2 is the
box on the right so its atoms have been shifted to the right
using Gromacs gmx editconf. The new merged gro file will be 
expanded using the bigger of the x, y coordinates and the 
sum of the z coordinates (plus a 1.0nm margin in z direction)

run by: python3 gro_merger.py Dea-Men11.gro Thy-Lid11.gro folder-path-to-save
"""

import sys, pandas as pd

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
    
    
# gro1 = "test/Dea-Men11_md.gro"
# gro2 = "test/Thy-Lid11_md.gro"

# print(gro1.split("/")[1])

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
    return max_x, max_y, max_z
    
    
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

merged_groname = gro1_name + "-" + gro2_name + ".gro"
# print(merged_groname)

# Grab the largest x, y, z coordinates from the molecule positions in the gro files
x3, y3, z3 = minmax_xyz(gro1)
x4, y4, z4 = minmax_xyz(gro2)

#  Select the largest coordinates to be used for the new merged box
new_x = max(x1, x2, x3, x4)  # New x dimension
new_y = max(y1, y2, y3, y4)  # New y dimension
new_z = max(z1,z3) + max(z2, z4) + 0.2  # New z dimension

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
with open(gro2, 'r') as r:
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
            

