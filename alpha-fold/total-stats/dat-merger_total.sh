#!/bin/bash
# This merges all the residue dat files in one dat file
# Useful for dat files not segregated by length.
for file in ???.dat
do
{
res=${file%.*}
echo $res
cat $file >> total-res_$1.dat
}
done

