#!/bin/bash
# created by ulab 10/10/2023
# This converts xpm to eps and png files in different folders 
cp APOE4/ss-dt10/res/ps.m2p /path/to/myscripts-162/protein-md/; 

for x in APOE2 APOE3 APOE4 APOE4-R269G APOE3-R154S APOE2-V254E; 
do 
cd $x/ss-dt10/res; 
find . -type f -name "APOE*-ssres-*xpm" | while read FILE
do
        /path/to/myscripts-162/protein-md/xpm2ps.sh $FILE
done
cd ../../.. 
done
