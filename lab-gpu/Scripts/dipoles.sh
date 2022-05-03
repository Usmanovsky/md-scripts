#!/bin/bash
source /path/to/gromacs2020.2/bin/GMXRC

name=$1-$2$3
f='_md'
w='Water'

mover(){
        mkdir $1
        mv *xvg ./$1
        mv *txt ./$1
        mv *dipole.log ./$1
}

 
{ echo 2; } | gmx_gpu dipoles -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $1-dipoles.xvg -slab $1-slab.xvg -sl 20 > $1-dipole.log
{ echo 3; } | gmx_gpu dipoles -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $2-dipoles.xvg -slab $2-slab.xvg -sl 20 > $2-dipole.log
{ echo 4; } | gmx_gpu dipoles -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $w-dipoles.xvg -slab $w-slab.xvg -sl 20 > $w-dipole.log

python3 /path/to/script/xvg2dat.py $1-slab.xvg
python3 /path/to/script/xvg2dat.py $2-slab.xvg
python3 /path/to/script/xvg2dat.py $w-slab.xvg

mover dipoles-$name

