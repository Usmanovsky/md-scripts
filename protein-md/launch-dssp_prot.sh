#!/bin/bash
# This script calls prot-analyzer for rmsd, rmsf, sasa and ss calculations.
prot=${1:-APOE}
x=$(date "+%d-%m-%Y"); nohup /path/to/myscripts-162/protein-md/dssp_prot.sh $prot >> $prot-dssp-$x.log 2>&1 &
