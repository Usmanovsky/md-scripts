#!/bin/bash
# ulab 09/30/2022
# This calls dat-to-out.py to get secondary structure info from dat files
# and store it in out files.

find $1 -maxdepth 2 -mindepth 1 -type f -name "*.pdb" | while read dir; do
#echo $dir
dat=${dir%.*}
echo $dat
python3 dat-to-out.py $dat
done
