# extract the information based on residue
# twenty amino acid

import sys

residue=['ALA','ARG','ASN','ASP','CYS','GLU','GLN','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL']

output_file=["" for i in range(len(residue))]

for i in range(20):
  filename=residue[i]+".dat"
  output_file[i]=open(filename,"a")


with open(sys.argv[1]) as input_file:
  for line in input_file:
   for k in range(len(residue)):
    if line.split()[0]==residue[k]:
      print(line[:-1],file=output_file[k])

print(sys.argv[1])
