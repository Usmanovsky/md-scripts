#!/bin/bash
# This loops through the csv files in different folders (segregated
# by length) and concats their stats to .boxplot files.
# It adds total stats first, then the rest to make life easy for
# plotting scripts.

for res in total*.csv
do
{
res1=${res%.*}
echo $res1
python3 stat-ss_total.py $res1 >> stat-ss_10_90.boxplot
}
done

for res in *.csv
do
case $res in *total-*) continue;; *batch*) continue;; esac
{
res1=${res%.*}
echo $res1
python3 stat-ss_total.py $res1 >> stat-ss_10_90.boxplot
}
done
