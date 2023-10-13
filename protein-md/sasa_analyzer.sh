#!/bin/bash
# This script calculates sasa for different regions of interest.
# $1 is the name of the protein, $2 is the name of the protein region
# $3 is the first residue number of the region of interest
# $4 is the second residue number of the region of interest

h='-noH'
AP="${1:-APOE}"
mvv(){ mkdir -p "${@: -1}" && mv "${@:1:$#-1}" "$_"; }
s="-sol1"
sa="-sasa"
id="${2:-lipid}"
res1="${3:-244}"
res2="${4:-272}"

# make index
{ echo "r $res1 - $res2"; echo q; } | gmx_gpu make_ndx -f $AP$s.gro -o $AP$sa-$id.ndx

# SASA for protein without H atoms
echo 18 | gmx_gpu sasa -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP$sa-$id.ndx -or $AP$h-$id-sasa-res.xvg -o $AP$h-$id-sasa-total.xvg -odg $AP$h-$id-sasa-energy.xvg -tu ns
#mvv *-sasa-*xvg sasa

# SASA for protein with H atoms
#echo 1 | gmx_gpu sasa -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP$sa.ndx -or $AP-sasa-res.xvg -o $AP-sasa-total.xvg -odg $AP-sasa-energy.xvg -tu ns
mvv *-$id-sasa-*.??? sasa-$id
