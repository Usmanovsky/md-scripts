#!/bin/bash
for res in *.csv
do
{
res1=${res%.*}
echo $res1
python3 stat-ss_10_90.py $res1 >> stat-ss_10_90.boxplot
}
done
