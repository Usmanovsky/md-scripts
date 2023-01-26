#!/bin/bash
# Find *out files and add them to corresponding *csv files.
# how-to-run: ./ss_out_2_csv.sh .
# This assumes the scripts and out-folders are in the same folder.
find $1 -type f -name "AF*.out" | xargs -I {} -P 1000 python3 analyze-ss_v2.py {};

#find $1 -type f -name "AF*.out" | while read dir; do
#    python analyze-ss.py $dir
#    echo $dir
#done
