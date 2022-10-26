#!/bin/bash
# ulab 09/30/2022
# This uses dssp to get secondary structure info from pdb files
# and store it in dat files. Make sure you install dssp on Linux
# or in conda
# $1 is the location of the pdb-folders.
find $1 -maxdepth 2 -mindepth 1 -type f -name "*.pdb" | while read dir; do
#echo $dir
dat=${dir%.*}
echo $dat
mkdssp $dir >> $dat.dat
done
