#!/bin/bash
# created by ulab 10/10/2023
# $1 is the name of the xpm file you want to convert to eps format

prot="${1:-APOE2}"
AP=`basename ${prot%.*}`
cp /path/to/myscript*/protein-md/ps.m2p .
gmx_gpu xpm2ps -f $prot -o $AP.eps -title none -di ps.m2p

# convert eps to png
convert $AP.eps $AP-trans.png

# change background from transparent to white
convert $AP-trans.png -background white -flatten $AP-white.png
