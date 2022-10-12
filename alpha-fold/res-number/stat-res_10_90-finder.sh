#!/bin/bash

#find $1 -maxdepth 2 -mindepth 1 -type f -name "*.dat" | while read dir; do
for dir in $1/*.dat
do
{
#echo $dir
dat=${dir%.*}
echo $dat
python3 stat-res_10_90-finder.py $dat >> stat-res_10_90.boxplot-$1
}
done
