#!/bin/bash
# Remove AF*.out files in parallel. Useful for when there are errors 
# in *.out files
find "$1" -maxdepth 1 -name "AF*.$2" -type f | xargs -I {} -P 1000 rm -r {};
