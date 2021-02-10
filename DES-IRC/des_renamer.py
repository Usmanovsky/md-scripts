# This creates DES simulation files from components kept in two different folders.
# Run the script using "python3 des_renamer.py DES/Compound 1/* DES/Compound 2/* 100 100"
# The above will create binary systems from each folder path and insert 100 mols of each
# Your directories might be different so set them up accordingly.
# created by ulab222

from pathlib import Path
from itpandgro import filesrenamer
import os, shutil, sys


def rewrite(path):    
    split_path = os.path.split(path)
#     print(split_path)
    return split_path[1]
    print('\n')
    
pathway = Path()   

if __name__ == "__main__":  # Accept command line inputs for  ligpargen files only if script is called directly.
    if len(sys.argv[1]) > 1:
        res1_path = str(sys.argv[1])
    else:
        res1_path = "DES/Compound 1/*"  # If empty, all the folders in ligpargen folder will be worked on
    
    
    if len(sys.argv[2]) > 1:
        res2_path = str(sys.argv[2])
    else:
        res2_path = "DES/Compound 2/*"
        
    if len(sys.argv[3]) > 1:
        molnumx = str(sys.argv[3])  # Number of molecules for Compound A
    else:
        molnumx = 50
        
                
    if len(sys.argv[4]) > 1:
        molnumy = str(sys.argv[4])  # Number of molecules for Compound B
    else:
        molnumy = 50
   

# These are placeholders that are replaced in each DES top file
x = 'molx'
y = 'moly'
numx = 'molnumx'
numy = 'molnumy'

# Set the folder name where the DES folders will be created in.
X = "X"

# Set the ligpargen variable to the folder containing the itp and gro files
ligpargen = "ligpargen"

# set the small-sys variable to the folder where the template mdp and top files are
smallsys = "small-sys"
oplsaa = "oplsaa.ff"

for folder1 in pathway.glob(res1_path):
    if os.path.isdir(folder1):
        res1 = rewrite(folder1)  # The name of compound A
    for folder2 in pathway.glob(res2_path):
        if os.path.isdir(folder2):
#             print(folder2)
            res2 = rewrite(folder2)  # The name of compound B
#             print(res2)
            if res1 == res2:
                pass
            else:                
                des_name = res1 + "-" + res2 + "11"  # Set DES folder name
                print(des_name)
    #             os.mkdir(f"X")        
                try:
                    os.mkdir(f"{X}/{des_name}")
                except FileExistsError:
                    print(f"{X}/{des_name} already exists") 
                    
                for number in range(1,4):  # Copying mdp and topology files              
                    mdp_path = des_name + str(number)
                    final_path = os.path.join(f"{X}/{des_name}", f"{mdp_path}.mdp")
                    print(final_path)
                    print("\n")
                    shutil.copy(f"{smallsys}/{number}.mdp", final_path)
                    
                    top_name = des_name  # set topology file name 
                    top_path = os.path.join(f"{X}/{des_name}", f"{top_name}.top")
                    print(top_path)
                    print("\n")
                    shutil.copy(f"{smallsys}/topology.top", top_path)
                    os.system(f"sed -i 's/{x}/{res1}/g' {top_path}")
                    os.system(f"sed -i 's/{y}/{res2}/g' {top_path}")
                    os.system(f"sed -i 's/{numx}/{molnumx}/g' {top_path}")
                    os.system(f"sed -i 's/{numy}/{molnumy}/g' {top_path}")
                    
                # Copying itp and gro files using the imported filesrenamer method. This works with the assumption
                # that all itp and gro files are kept in a folder called ligpargen. Set ligpargen variable to your folder name, if different.
                itp1_path = os.path.join(f"{X}/{des_name}", f"{res1}.itp")
                itp2_path = os.path.join(f"{X}/{des_name}", f"{res2}.itp")
                gro1_path = os.path.join(f"{X}/{des_name}", f"{res1}.gro")
                gro2_path = os.path.join(f"{X}/{des_name}", f"{res2}.gro")
                
                if os.path.isfile(f"{ligpargen}/{res1}/{res1}.itp") and os.path.isfile(f"{ligpargen}/{res1}/{res1}.gro"):  # 
                    #itp_path = os.path.join(f"X/{des_name}", f"{res1}.itp")
                    shutil.copy(f"{ligpargen}/{res1}/{res1}.itp", itp1_path)
                    shutil.copy(f"{ligpargen}/{res1}/{res1}.gro", gro1_path)
                else:
                    folderpath = f"{ligpargen}/{res1}"
                    filesrenamer(folderpath)
                    shutil.copy(f"{ligpargen}/{res1}/{res1}.itp", itp1_path)
                    shutil.copy(f"{ligpargen}/{res1}/{res1}.gro", gro1_path)
                
                
                if os.path.isfile(f"{ligpargen}/{res2}/{res2}.itp") and os.path.isfile(f"{ligpargen}/{res2}/{res2}.gro"):
                    #itp_path = os.path.join(f"X/{des_name}", f"{res2}.itp")
                    shutil.copy(f"{ligpargen}/{res2}/{res2}.itp", itp2_path)
                    shutil.copy(f"{ligpargen}/{res2}/{res2}.gro", gro2_path)
                else:
                    folderpath = f"{ligpargen}/{res2}"
                    filesrenamer(folderpath)
                    shutil.copy(f"{ligpargen}/{res2}/{res2}.itp", itp2_path)
                    shutil.copy(f"{ligpargen}/{res2}/{res2}.gro", gro2_path)
                    
                
                
                try:
                    shutil.copytree(f"{oplsaa}/", f"{X}/{des_name}/oplsaa.ff")  # This only works if there is an oplsaa.ff folder in the working directory
                except FileExistsError:
                    print(f"{X}/{des_name}/oplsaa.ff already exists")
              
                
                
