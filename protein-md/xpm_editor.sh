#!/bin/bash
# created by ulab 10/10/2023
# This script extracts residues of interest from an xpm file. 
# $1 is the name of the protein folder containing the xpm file,
# $2 is the ID of the first residue in the region of interest
# $3 is the ID of the last residue in the region of interest

prot="${1:-APOE2}"
res_begin="${2:-136}"
res_end="${3:-166}"

python3 /path/to/myscripts-162/protein-md/xpm_editor.py $prot $res_begin $res_end
