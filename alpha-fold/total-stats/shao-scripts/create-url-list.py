import pandas as pd
import sys 


file_in=open(sys.argv[1],"r")
file_out=open(sys.argv[2],"w")

with open(sys.argv[1]) as f:
    for line in f:
      uniprot=line[:-1]
      url="https://alphafold.ebi.ac.uk/files/AF-"+uniprot+"-F1-model_v3.pdb"
      print(url,file=file_out)
