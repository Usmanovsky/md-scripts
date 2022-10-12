#!/bin/bash
# Find *out files and add them to corresponding *csv files.
find $1 -maxdepth 1 -mindepth 1 -type f -name "AF*.out" | while read dir; do
    python analyze-ss.py $dir
done
