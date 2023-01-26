#!/bin/bash
# This merges all the ss csv files in one csv file
for file in $1/*.csv
do
{
ss=${file%.*}
echo $ss
cat $file >> $1/total-ss-$1.csv
}
done
