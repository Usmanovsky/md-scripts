#!/bin/bash
for res in $1/*.csv
do
{
res1=${res%.*}
echo $res1
python3 stat-ss_10_90-finder.py $res1 >> stat-ss_10_90.boxplot-$1
}
done
