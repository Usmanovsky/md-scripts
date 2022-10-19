#!/bin/bash
for res in *.dat
do
{
res1=${res%.*}
echo $res1
python stat-residue.py $res1 >> stat-res.boxplot
}
done
