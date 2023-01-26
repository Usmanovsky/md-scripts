#!/bin/bash
# Find *out files and add them to corresponding *dat files.
find $1 -type f -name "AF*.out" | while read dir; do
    python analyze-residue.py $dir
done
