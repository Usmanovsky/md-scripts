#!/bin/bash
# This merges all the ss csv files in one csv file
# Useful for csv files not segregated by length
for file in *.csv
do
case $file in *batch*) continue;; esac
{
ss=${file%.*}
echo $ss
cat $file >> total-ss_$1.csv
}
done
