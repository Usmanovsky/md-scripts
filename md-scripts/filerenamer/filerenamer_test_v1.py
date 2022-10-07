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
    old_oplstags = set()

    for files in pathway.glob("{target}/*".format(target=folder)):
        # print(files)
        opls_lines = set()
        old_path = os.path.split(files)
#         print(old_path)
        old_resname = files.stem[0:3]
#         print(old_resname)        
        
        if files.name.__contains__(".itp"):
            new_itp = f"{new_resname}.itp"
            new_path = os.path.join(old_path[0],new_itp)
            # print(new_path)
            
            os.system(f"sed 's/{old_resname}/{new_resname}/g' {files} > {new_path}")
            with open(new_path, 'r') as f:  # Replace residue names with folder names
                lines = f.readlines()
                for line in lines:
                    stripped_line = line.strip()
    #                 print(stripped_line)
                    split_line = stripped_line.split(' ')
    #                 print(split_line)
                    opls = [x for x in split_line if x.__contains__('opls')]
                    if len(opls)>0:                        
                        old_oplstags.add(opls[0])                 
            
            
            print(len(old_oplstags))            
                        
            for member in (old_oplstags):
                old_tag = str(member)
                print(old_tag)
                new_oplstag = old_tag + new_resname
                print(new_oplstag)             
                os.system(f"sed -i 's/{old_tag}/{new_oplstag}/g' {new_path}")                                       
                print('\n')

            
            with open(new_path, 'r') as f:  
                lines = f.readlines()
#             print(lines)
            with open(new_path, 'w') as f:  # Rewrite itp file without the [ atomtypes ]

            with open(pathway.glob("oplsaa.ff/ffnonbonded_new.itp"), 'a') as ff:  
                if counter < 1:
                    ff.write(f"\n\n; {new_name} (Added by Usman & Joseph {localtime})")
                for line in lines:
                    stripped_line = line.strip()
                    split_line = stripped_line.split()
                    
                    if split_line[0] in opls_lines:  # Writing in ffnonbonded_new.itp
                        pass
                    elif split_line[0].__contains__('opls'):
                        opls_lines.add(split_line[0])
                        ff.write(line)

                    if stripped_line.__contains__("atomtypes") or split_line[0].__contains__('opls'):
                        counter +=1
                    else:
                        f.write(line)
                

                
        elif files.name.__contains__(".gro"):
            new_gro = f"{new_resname}.gro"
            new_path = os.path.join(old_path[0], new_gro)
            print(new_path)
            os.system(f"sed 's/{old_resname}/{new_resname}/g' {files} > {new_path}")