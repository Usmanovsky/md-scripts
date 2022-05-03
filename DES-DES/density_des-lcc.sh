#!/bin/bash
module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130
module load ccs/conda/python-3.8.0

source /path/to/gromacs2021.2/bin/GMXRC

# how to run: ../../density_des-lcc.sh CHO URE Cld 11 50
# $1, $2 and $3 are the DES compound names, #4 is the molar ratio
# $% is the number of slicses for gmx density
name=$1-$2$4
one=1
two=2
c='_boxed'
three=3
f='_md'
w='water'
num=$5
mover(){
        mkdir $1
        mv *xvg ./$1
        mv *density.log ./$1
}

{ echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx
{ echo 2; echo 2; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $1-density.xvg -relative -sl $num > $1-density.log
{ echo 3; echo 3; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $2-density.xvg -relative -sl $num > $2-density.log
{ echo 4; echo 4; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $3-density.xvg -relative -sl $num > $3-density.log
#{ echo 5; echo 5; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $4-density.xvg -relative -sl $8 > $4-density.log
#{ echo 6; echo 6; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $5-density.xvg -relative -sl $8 > $5-density.log

mover density-$name
cd density-$name
~/myscri*/unxvg2txt.sh '*'
