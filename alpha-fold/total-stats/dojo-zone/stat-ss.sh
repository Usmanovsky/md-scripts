#!/bin/bash
for res in *.csv
do
{
res1=${res%.*}
echo $res1
python stat-ss.py $res1 >> stat-ss.boxplot
}
done
