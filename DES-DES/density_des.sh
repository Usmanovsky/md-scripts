#!/bin/bash

# how to run: ../../density_des-lcc.sh CHO URE Cld 11 50
# $1, $2 and $3 are the DES compound names, #4 is the molar ratio
# $5 is the number of slices for gmx density

PS3='Please enter your choice: '
options=("lcc" "lab GPU" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            echo "you chose $opt"
            module purge
            module load gnu7/7.3.0
            module load openmpi3/3.1.0
            module load cmake
            #module load ccs/cuda/10.0.130
            module load ccs/conda/python-3.8.0
            source /project/qsh226_uksr/DES_usman/gromacs2021.2/bin/GMXRC
            scriptpath=~/myscri*
            ;;
        "${options[1]}")
            echo "you chose $opt"
            source /data/ulab222/gromacs-2021.2/bin/GMXRC
            scriptpath=/data/ulab222/myscri*/Analysis
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

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
{ echo 0; echo 0; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $name-density.xvg -relative -sl $num > $name-density.log

mover density-$name
cd density-$name
$scriptpath/unxvg2txt.sh '*'
