import sys
import hashlib

file2=open('v3-affected.csv',"w+")

with open(sys.argv[1]) as f:
    for line in f:
        uniprot=line.split('-')[1]
#        val=hashlib.sha256(uniprot.encode())
        print(uniprot, file=file2)


