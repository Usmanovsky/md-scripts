#!/bin/bash

# This script creates boxplot files for length-segregated dat files
# It adds the total stats first, because the plotting scripts demand
# it
for dir in $1/total*.dat
do
{
dat=${dir%.*}
echo $dat
python3 stat-res_10_90-finder.py $dat >> stat-res_10_90.boxplot-$1
}
done

for dir in $1/?[^o]*.dat 
do
{
dat=${dir%.*}
echo $dat
python3 stat-res_10_90-finder.py $dat >> stat-res_10_90.boxplot-$1
}
done
