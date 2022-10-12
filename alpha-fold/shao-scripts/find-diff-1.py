import sys

file_ref=open(sys.argv[1],"r")
file_db=open(sys.argv[2],"r")
file_out=open(sys.argv[3],"w+")

lines_ref=file_ref.readlines()
lines_db=file_db.readlines()

for line1 in lines_db:
#    print(line1)
    flag=0
    for line2 in lines_ref:
        if line1 == line2:
            flag=1
    if flag==0:
        print(line1[:-1],file=file_out)


