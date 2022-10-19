#!/bin/bash
# This merges all the residue dat files in one dat file
for file in *dat
do
{
res=${file%.*}
echo $res
cat $file >> total/total-res.dat
}
done

