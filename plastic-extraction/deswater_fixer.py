'''This function takes in a gro file and deletes molecules based on certain criteria e.g a 
solvated box where water molecules have creeped into unwanted zpnes. In this case, the z 
 coordinate  interests us. It is based on gro_analyser. solvated_gro is the file path of 
 the .gro file, sol is the molecule we are interested in deleting, wall_limit is the z 
 coordinate based on which molecules are deleted.

 how to run: python3 deswater_fixer.py ./Thy-Lid11_solvated SOL 5.66

 The above will delete all SOL molecules with z < 5.66
'''
import sys
import pandas as pd

def groliness(filename, contains, wall):
    # wall = 4.56075
    gro = filename + ".gro"
    df = pd.read_csv(gro, sep='\s+', skiprows=[0,1], header=None)
    deletedgrolines = filename + "_deletedlines.gro"
    num_deleted_lines = 0
    with open(gro, 'r') as m:
        lines = m.readlines()
        gro2 = filename + "_copy.gro"
        deleted = []
        loopdelete = []
    # with open(gro_delete, 'w')
    with open(gro2, 'w') as output:
        df_count = -3
        for x in lines:
            df_count += 1
            z = x.strip()
            if z.__contains__(contains):
                # print(z)
                spacesplit = z.split(' ')
                # print(spacesplit)
                # print(spacesplit[-1])
                print('\n')
                # temp = spacesplit[-1]
                if df_count <= 9998:
                    temp = df.iloc[df_count,5]
                    print(f"row: {df_count}, z = {temp}")
                else:
                    temp = df.iloc[df_count,4]
                    print(f"row: {df_count}, z = {temp}")
                    
                try:
                    num = float(temp)
                    if num >= wall:
                        output.write(x)
                    else:
                        deleted.append(f"{spacesplit} was not printed. {num} failed the test")
                        loopdelete.append(spacesplit[0])
                        num_deleted_lines += 1
                        pass
                except ValueError:
                    print("Not a number ")
            else:
                output.write(x)
        print("The gro file has been cleaned up and stored in ", gro2)
        # print(deleted)
        print(loopdelete)
        loopdelete2set = set(loopdelete)  # This ensures only unique values are stored
        print(loopdelete2set.__len__())
    with open(deletedgrolines, 'w') as d:  # This stores the deleted lines in a gro file
        for each in deleted:
            d.write(each)
            d.write('\n'*2)
        print("\n")
        print(f"Deleted {num_deleted_lines} lines in {gro2} and recorded them in {deletedgrolines}")
        print("\n")

    with open(gro2, 'r') as filecheck:  # This runs a final check on the edited gro file
        linepack = filecheck.readlines()
        counter = 0  # This allows you to count how many lines you skipped
        gro_final = filename + "_edited.gro"
        with open(gro_final, 'w') as g:
            for line in linepack:
                if line.__contains__(contains):
                    stripped = line.strip().split(' ')
                    if stripped[0] in loopdelete2set:
                        # print(stripped[0])  # This allows you to see which lines you skipped
                        counter += 1
                        pass
                    else:
                        g.write(line)
                else:
                    g.write(line)
        deleted_atoms = counter + num_deleted_lines
        print(f"Deleted {counter} lines in {gro2}, that's a total of {deleted_atoms}")

    
    with open(gro_final, 'r') as r:
        lines = r.readlines()
        updated_groname = filename + "_final.gro"
        with open(f"{updated_groname}",'w') as updated:
            for line in lines:
                if line == lines[1]:
                    total_atoms = int(line.strip().split()[0])
                    total_atoms = total_atoms - deleted_atoms
                    updated.write(str(total_atoms) + "\n")            
                else:
                    updated.write(line)
    print("\n")
    df = pd.read_csv(updated_groname, sep='\s+', skiprows=[0,1], header=None)
    water_atoms = len(df[df[0].str.contains(contains)])  # Count the number of water atoms left
    print(f"{total_atoms} water atoms were deleted; there are {water_atoms} atoms ({water_atoms/4} water molecules) left. The final gro file has been written to {updated_groname}")



if __name__ == "__main__":  # Accept command line inputs for gro files if script is called directly.
    try:
        if len(sys.argv[1]) > 1 and len(sys.argv[2]) > 1 and len(sys.argv[3]) > 1:
            solvated_gro = str(sys.argv[1])
            sol = str(sys.argv[2])
            wall_limit = float(sys.argv[3])
            # groliness(solvated_gro, sol, wall_limit)
        else:
            print("Check your inputs. Something is wrong with them") 
        
    except TypeError:
        print("Inputs are not correct.")
    
    groliness(solvated_gro, sol, wall_limit)








