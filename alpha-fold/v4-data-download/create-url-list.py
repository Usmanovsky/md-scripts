# This will create a list of urls that can then be used to download pdb files
import pandas as pd
import sys 


file_in=open(sys.argv[1],"r")
file_out=open(sys.argv[2],"w")

with open(sys.argv[1]) as f:
    for line in f:
      uniprot=line[:-1]     
      line=line.strip("\n") + "-model_v4.pdb"  # v4 AF DB
      url=f"https://alphafold.ebi.ac.uk/files/{line}"      
      print(url,file=file_out)
