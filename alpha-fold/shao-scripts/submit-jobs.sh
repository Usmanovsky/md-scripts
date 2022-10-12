#!/bin/bash


for i in {3..20}
do
{
cp organize-data-ss.py folder-$i/
cd folder-$i
sbatch output-dssp-mcc-folder.sh 
cd ..
}
done


