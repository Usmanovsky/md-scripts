# extract the PLDDT and SS info based on number of residues
# and add to the appropriate dat file.

import sys

file_path = sys.argv[1]
res_num = sys.argv[2]
residue=['ALA','ARG','ASN','ASP','CYS','GLU','GLN','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL']

output_file=["" for i in range(len(residue))]

for i in range(20):
  filename=residue[i]+".dat"
  output_file[i]=open(f"{res_num}/{filename}","a")


with open(file_path) as input_file:
  for line in input_file:
   for k in range(len(residue)):
    if line.split()[0]==residue[k]:
      print(line[:-1],file=output_file[k])
      print(f"Added line to {output_file[k]}")
  
