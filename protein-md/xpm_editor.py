import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path
import numpy as np
import os, sys
import datetime

pathway = Path()
prot_folder = sys.argv[1]
res_begin = int(sys.argv[2])
res_end = int(sys.argv[3]) + 1  # this handles python's counting from zero issue.

def dirmaker(path):
    '''
    path is the folder path you want to make if it exists
    '''
    if os.path.isdir(path):
        pass
    else:
        os.makedirs(path)
        pass


xdate = datetime.datetime.now().strftime("%m-%d-%Y")


for file in pathway.glob(f"{prot_folder}"):  # path to protein folder
    if not file.is_dir:
        continue

    # This section sets the residues of interest. Change as needed
    start_res = res_begin
    end_res = res_end
    n_terminal = [x for x in range(start_res,end_res)]
    new_value = n_terminal[-1] - n_terminal[0]
    new_value += 1
    static_line = ""
    static_line_bool = False

    for txt in pathway.glob(f"{file}/ss-dt10/APOE*-ss.xpm"): # grab xpm file in protein folder       
        print(txt)
        count = 0
        with open(txt, 'r+') as r:  
            lines = r.readlines()
            # print(lines)
            residue_ss = {i:res for i,res in enumerate(lines) if ("/*" not in res.strip(' \n') or "*/" not in res.strip(' \n')) and "static " not in res.strip(' \n') and i > 10}  # grab only the lines containing residue info
            
            # The xpm is in reverse order so the residue IDs have to be corrected.
            residue_id = [ x for x in range(1, 300)]
            # print(residue_id)
            residue_id.sort(reverse=True)
            # print(residue_id)
            residue_ss = dict(zip(residue_id, residue_ss.values()))
            # print(residue_ss)

        
        # Write everything before the y-axis section
        new_xpm = f'{file.stem}-ssres-{n_terminal[0]}-{n_terminal[-1]}.xpm'
        dirmaker(f"{file}/ss-dt10/res/")
        with open(f"{file}/ss-dt10/res/{new_xpm}", 'w') as w:
            for line_w in lines:
                strip_line_w = line_w.strip(' \n')
                if "y-axis" not in strip_line_w:
                    if static_line_bool:  
                        static_line = line_w
                        print(f"static: {static_line}")
                        old_value = static_line.split(' ')[1]
                        new_string = static_line.replace(f"{old_value}", f"{new_value}")
                        w.write(new_string)  # update the size of the y-axis since we have deleted several lines
                        static_line_bool = False
                    else:
                        w.write(line_w)
                    # print(line_w)
                else:
                    break
                

                if "static char" in strip_line_w:
                    static_line_bool = True


            # Write the y-axis section
            y_axis_str = "/* y-axis: "
            y_axis_str_end = " */\n"
            y_axis = " "
            for num in n_terminal:
                y_axis_str = y_axis_str.__add__(f" {num}") 


            y_axis_str = y_axis_str.__add__(y_axis_str_end)
            w.write(y_axis_str)

            n_terminal.sort(reverse=True)

            # write the secondary structure for the portion of interest
            for x in n_terminal:                
                if x == n_terminal[-1]:
                    w.write(residue_ss[x][:-2])
                else:
                    w.write(residue_ss[x])
        
       
