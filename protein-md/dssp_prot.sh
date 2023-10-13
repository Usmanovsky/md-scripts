#!/bin/bash
# This script calculates rmsd, rmsf, contact map and sasa.
#source ~/.bashrc
AP="${1:-APOE}"
mvv(){ mkdir -p "${@: -1}" && mv "${@:1:$#-1}" "$_"; }

# SS
export DSSP=/data1/qsh226/anaconda3/bin/mkdssp
echo 7 | gmx_gpu do_dssp -f $AP-sol5.trr -s $AP-sol1.tpr -n $AP-sol -ssdump $AP-ssdump.dat -o $AP-ss.xpm -sc $AP-scount.xvg -dt 10 -tu ns

gmx_gpu xpm2ps -f $AP-ss.xpm -o $AP-ss.eps -title none -di ps.m2p
mvv *-ss.eps *ssdump.dat *scount.xvg *-ss.xpm ss-dt10
