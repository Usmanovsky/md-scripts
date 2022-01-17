#  This function takes in a gro file and deletes lines based on certain criteria. In this case, the z coordinate
#  interests us. It is based on gro_analyser. gro is the full name of the .gro file, contains is the tag we are
# interested in.


def groliness(filename, contains):
    wall = 4.56075
    gro = filename + ".gro"
    deletedgrolines = filename + "_deletedlines.gro"
    num_deleted_lines = 0
    with open(gro, 'r') as m:
        lines = m.readlines()
        gro2 = filename + "_copy.gro"
        deleted = []
        loopdelete = []
    # with open(gro_delete, 'w')
    with open(gro2, 'w') as output:
        for x in lines:
            z = x.strip()
            if z.__contains__(contains):
                print(z)
                spacesplit = z.split(' ')
                print(spacesplit)
                print(spacesplit[-1])
                print('\n')
                temp = spacesplit[-1]
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
        print(f"Deleted {counter} lines in {gro2}, that's a total of {counter + num_deleted_lines}")
    print("\n")
    print(f"The final gro file has been written to {gro_final}")



groliness("correction\Men-Lid21-solvated", "SOL")






