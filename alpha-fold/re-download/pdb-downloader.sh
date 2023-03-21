#!/bin/bash
# This script reads AlphaFold IDs from a file and downloads

link='https://alphafold.ebi.ac.uk/files'
while IFS= read -r line; do
    echo "AlphaFoldDB ID: $line"
    #wget $link/$line-model_v4.pdb
    wget $line
done < "$1"

