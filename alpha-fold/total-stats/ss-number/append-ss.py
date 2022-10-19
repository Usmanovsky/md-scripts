# extract the ss information based on number of residues

import sys

file_path = sys.argv[1]
res_num = sys.argv[2]
ss=['~','E','B','T','S','H','G']
ss_name=['coil','beta-sheet','beta-bridge','turn','bend','ahelix','three-helix']

output_file=["" for i in range(len(ss_name))]

for i in range(len(ss_name)):
  filename=ss_name[i] + ".csv"
  output_file[i]=open(f"{res_num}/{filename}","a")


with open(file_path) as input_file:
  for line in input_file:
   if len(line.split())==3:
    for k in range(len(ss_name)):
     if line.split()[2]==ss[k]:
      print(line[:-1],file=output_file[k])
      print(f"Added line to {output_file[k]}") 
