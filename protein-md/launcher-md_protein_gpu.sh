#!/bin/bash
prot=$1
x=$(date "+%d-%m-%Y")
nohup /path/to/myscripts-202/protein-md/md_protein.sh $prot >> $prot-md-$x.log 2>&1 &
