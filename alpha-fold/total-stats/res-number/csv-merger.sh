#!/bin/bash
# This merges all the ss csv files in one csv file
for file in *.csv
do
{
ss=${file%.*}
echo $ss
cat $file >> total/total-ss.csv
}
done
