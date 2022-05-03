#!/bin/bash
source /path/to/gromacs-2020.4/bin/GMXRC

# This script converts trr or xtc to gro files. $4 is the trr/xtc file name
# This assumes all your files are in the same working directory.

name=$1-$2$3
one=1
two=2
three=3
f='_md'
i='interface'
w='water'


mover(){
        mkdir $1
        mv $i*gro ./$1
        mv *$i.log ./$1
}

gmx_gpu trjconv -f $4  -s $name$f.tpr  -n $name.ndx  -o $i-$name.gro -pbc whole > $name-$i.log
mover Interface-$name
