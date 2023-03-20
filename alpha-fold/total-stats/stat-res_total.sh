#!/bin/bash
# This script creates boxplot files for dat files
# It adds the total stats first, because the plotting scripts demand
# it
for dir in total*.dat
do
{
dat=${dir%.*}
echo $dat
python3 stat-res_total.py $dat >> stat-res_10_90.boxplot
}
done

for dir in ???.dat
do
{
dat=${dir%.*}
echo $dat
python3 stat-res_total.py $dat >> stat-res_10_90.boxplot
}
done
