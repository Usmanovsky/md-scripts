# this code extracts amino acid and PLDDT from the pdb file (downloaded from alphafold) 
# and secondary structure from the dat file (produced by dssp in a conda env) and 
# stores the results in an .out file

import sys
import numpy

name=sys.argv[1]

pdb_name=name+".pdb"
ss_name=name+".dat"
out_name=name+".out"

file_ss=open(ss_name,"r")
file_out=open(out_name,"w+")

# skip the first 28 line for the secondary structure file
for i in range(28):
  file_ss.readline()

with open(pdb_name) as file_pdb:
  for line in file_pdb:
    if line.split()[0]=='ATOM':
      if (line.split()[2]=='CA'):
        ss=file_ss.readline()[16]
        # print(file_ss.readline())
        # print(ss)
        if (ss==' '):
          ss='~'
        print(line.split()[3],line.split()[10],ss,file=file_out)
