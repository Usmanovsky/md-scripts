#!/bin/bash
for res in *.csv
do
{
res1=${res%.*}
echo $res1
python3 stat-ss_total.py $res1 >> stat-ss_total.boxplot
}
done
