# -*- coding:utf-8 -*- 
#!/usr/bin/python
import os
import re
import sys
import copy
import numpy as np

#this function is used to get rid of the nonessential data in xvg files
#and write new csv files that can be easily used to plot with matplotlib 
def convert(xvgfile,csvfile):
    sfile = open(xvgfile, "r")
    dfile = open(csvfile, "a")
    labelgroup=[]
    content=[]
    pattern = r'"(.*?)"'
    for eachLine in sfile:
        #line starts with @ or # are nonessential data,just pass
        if eachLine.startswith('#'): 
            pass
        elif eachLine.startswith('@'):
            if 'label' in eachLine:
                labels= re.findall(pattern,eachLine)
                #print(labels)
                try:
                    if len(labels[0].split())==1:
                        labelgroup.append(labels[0].split()[0])
                    else:
                        labelgroup.append(labels[0].split()[0])
                        labelgroup.append(labels[0].split()[1].strip("(").strip(")"))                   
                except:
                    print("legend出现错误")
                    labelgroup.append("")
                    labelgroup.append(labels[0].split()[0].strip("(").strip(")"))
                
        else:
            try:
                content.append(eachLine.strip())
            except:
                print ("Wrong!")
    con=""
    cont=""
    for i in range(0,len(labelgroup),2):
        line = labelgroup[i]+ "   "
        con+=line
        try:
            line1 = labelgroup[i+1]+ "   "
            cont+=line1
        except:
            pass
    ret = copy.deepcopy(content)
    content.insert(0,cont)
    content.insert(0,con)
    #print content 
    dfile.writelines([liness+"\n"  for liness in content])
    sfile.close()
    dfile.close()
    return ret
    
#read the xvg files in the directory and convert to new csv files. 
if len(sys.argv) == 1:
    lists=os.listdir(os.getcwd())
else:
    lists=[sys.argv[1]]
#try:
    #import termplotlib as tpl
    #import numpy as np
#except ImportError:
 #   print("Try pip install termplotlib numpy")
    #sys.exit(1)
for i in lists:
    eac = []
    if ".xvg" in i:
        parm_out_file=i.split('.',1)[0]+'.txt'
        #if the csv files exist,remove them.This is helpful if you
        #want to run the script several times
        if os.path.isfile(parm_out_file):
            os.remove(parm_out_file)
        ret=convert(i,parm_out_file)
        for j in ret:
            #print(j)
            eac.append(list(map(float,j.split())))
        eac=np.array(eac)
        #fig = tpl.figure()
        #for k in range(1,len(eac[0])):
        #    fig.plot(eac[:,0], eac[:,k], width=30, height=30)
        #fig.show()
        
print("Finished xvg to txt conversion!")