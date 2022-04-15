from pathlib import Path
import os, shutil

pathway = Path()
# folders = [file.name for file in pathway.glob('Compound 1/*')]
folders = [file.name for file in pathway.glob('test/*')]


def rewrite(path):    
    split_path = os.path.split(path)
#     print(split_path[1])
    return split_path[1]
    print('\n')
    
for folder in pathway.glob('test/*'):
#     print(folder)
    new_resname = rewrite(folder)
#     print(new_name)
    for files in pathway.glob("{target}/*".format(target=folder)):
#         print(files)
        old_path = os.path.split(files)
#         print(old_path)
        old_resname = files.stem[0:3]
#         print(old_resname)
        
        
        if files.name.__contains__(".itp"):
            new_itp = f"{new_resname}.itp"
            new_path = os.path.join(old_path[0],new_itp)
            print(new_path)
            os.system(f"sed 's/{old_resname}/{new_resname}/g' {files} > {new_path}")
        elif files.name.__contains__(".gro"):
            new_gro = f"{new_resname}.gro"
            new_path = os.path.join(old_path[0], new_gro)
            print(new_path)
            os.system(f"sed 's/{old_resname}/{new_resname}/g' {files} > {new_path}")