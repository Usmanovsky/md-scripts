#!/bin/bash
# This merges all the residue dat files in one dat file
for file in $1/*dat
do
{
res=${file%.*}
echo $res
cat $file >> $1/total-res-$1.dat
}
done

