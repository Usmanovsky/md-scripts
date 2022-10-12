#!/bin/bash
# Find *out files and add them to corresponding *dat files.
find $1 -type f -name "AF*.out" | xargs -I {} -P 1000 python3 analyze-residue.py {};

#find $1 -type f -name "AF*.out" | while read dir; do
#    python analyze-residue.py $dir
#    echo $dir
#done
