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
    new_name = rewrite(folder)
    for files in pathway.glob("{target}/*".format(target=folder)):
        print(files.name)
        old_resname = files.stem[0:3]
        print(old_resname)
        
        if files.name.__contains__(".itp"):
            os.system(f"sed 's/{old_resname}/{new_name}/g' {files.name} > {new_name}.itp")
        elif files.name.__contains__(".gro"):
            os.system(f"sed 's/{old_resname}/{new_name}/g' {files.name} > {new_name}.gro")