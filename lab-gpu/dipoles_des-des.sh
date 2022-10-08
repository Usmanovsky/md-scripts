#!/bin/bash
source /data/ulab222/gromacs-2021.2/bin/GMXRC

# This script calculates dipoles for the four components in a DES-DES box. For CHOURE11-DeaMen11, run by:
# ./dipoles_des-des.bash CHO URE Dea Men 11

name=$1$2-$3$4$5
f='_md'
w='Water'

mover(){
        mkdir $1
        mv *xvg ./$1
        mv *txt ./$1
        mv *dipole.log ./$1
}

 
{ echo 2; } | gmx_gpu dipoles -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $1-dipoles.xvg -slab $1-slab.xvg -sl 70 > $1-dipole.log
{ echo 3; } | gmx_gpu dipoles -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $2-dipoles.xvg -slab $2-slab.xvg -sl 70 > $2-dipole.log
{ echo 4; } | gmx_gpu dipoles -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $3-dipoles.xvg -slab $3-slab.xvg -sl 70 > $3-dipole.log
{ echo 5; } | gmx_gpu dipoles -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $4-dipoles.xvg -slab $4-slab.xvg -sl 70 > $4-dipole.log

/data/ulab222/myscri*/unxvg2txt.sh '*'
mover dipole-$name

