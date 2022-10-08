#!/bin/bash
source /data/ulab222/gromacs-2021.2/bin/GMXRC


name=$1$2-$3$4$5
one=1
two=2
three=3
f='_md'
w='water'

mover(){
        mkdir $1
        mv *xvg ./$1
        mv *txt ./$1
        mv *density.log ./$1
}

{ echo 2; echo 2; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $1-density.xvg -relative > $1-density.log
{ echo 3; echo 3; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $2-density.xvg -relative > $2-density.log
{ echo 4; echo 4; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $3-density.xvg -relative > $3-density.log
{ echo 4; echo 5; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $4-density.xvg -relative > $4-density.log

/data/ulab222/myscri*/unxvg2txt.sh '*'
mover density-$name

