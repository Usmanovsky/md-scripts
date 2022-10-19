#!/bin/bash
# Find *out files and add them to corresponding *csv files.
find $1 -type f -name "AF*.out" | xargs -I {} -P 1000 python3 analyze-ss.py {};

#find $1 -type f -name "AF*.out" | while read dir; do
#    python analyze-ss.py $dir
#    echo $dir
#done
