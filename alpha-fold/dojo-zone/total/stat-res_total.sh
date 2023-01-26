#!/bin/bash
for res in *.dat
do
{
res1=${res%.*}
echo $res1
python3 stat-res_total.py $res1 >> stat-res_total.boxplot
}
done
