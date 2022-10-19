import pandas as pd
import sys

file1=open(sys.argv[1])
file2=open(sys.argv[2])
file3=open(sys.argv[3])


label=pd.read_csv(file1)
ref=pd.read_csv(file2)


