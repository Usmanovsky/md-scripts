#!/bin/bash
source /path/to/gromacs2021.2/bin/GMXRC

# This script shifts molecules in a box along the z axis. $4 is the length to shift.
# This assumes all your files are in the same working directory.

name=$5
new_name=$1$2$3
one=1
two=2
three=3
f='_md'
i='interface'
w='water'
s='_shifted'

mover(){
        mkdir $1
        mv *gro ./$1
        mv *.log ./$1
}

echo 'START of shifting'
gmx_gpu editconf -f $name.gro -o $new_name.gro -translate 0 0 $4  > $new_name$s.log
echo 'END OF shifting'
