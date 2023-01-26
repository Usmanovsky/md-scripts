# extract the information based on residue
# 8 secondary structures
# Added a new SS (5-turn-helix)
import sys

ss=['~','E','B','T','S','H','G','I']
ss_name=['coil','beta-sheet','beta-bridge','turn','bend','ahelix','three-helix','five-helix']
output_file=["" for i in range(len(ss_name))]

for i in range(len(ss_name)):
  filename=ss_name[i]+".csv"
  output_file[i]=open(filename,"a")


with open(sys.argv[1]) as input_file:
  for line in input_file:
   if len(line.split())==3:
    for k in range(len(ss_name)):
     if line.split()[2]==ss[k]:
      print(line[:-1],file=output_file[k])


print(sys.argv[1])
