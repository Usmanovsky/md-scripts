"""This script spits out the max and min x y z positions in a gro file (gro1).

run by: python3 minmax-xyz.py Dea-Men11.gro
"""

import sys, pandas as pd

if __name__ == "__main__":  # Accept command line inputs for gro files if script is called directly.
    try:
        if len(sys.argv[1]) > 1:
            gro1 = str(sys.argv[1])
            #gro2 = str(sys.argv[2])
        else:
            print("Check your file paths. Something is wrong with them") 
        
    except TypeError:
        print("File paths are not correct.")
    


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
#num_atoms2, x2, y2, z2 = atomsfinder(gro2)
#total_atoms = num_atoms1 + num_atoms2

# Grab the largest x, y, z coordinates from the molecule positions in the gro files
x3, y3, z3 = minmax_xyz(gro1)
#x4, y4, z4 = minmax_xyz(gro2)



