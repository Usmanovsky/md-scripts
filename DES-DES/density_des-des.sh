#!/bin/bash
# how to run: ../../density_des-lcc.sh CHO URE 11 Dea Men 11 Cld 50
# $1, $2 are the DES compound names for the 1st DES, #3 is their molar ratio
# $4, $5 are the DES compound names for the 2nd DES, #6 is their molar ratio
# $7 is the counter-ion. $8 is the number of slices for gmx density

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
	    module load ccs/cuda/10.0.130
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


name=$1$2$3-$4$5$6
one=1
two=2
three=3
f='_md'
w='water'
num=$8
mover(){
        mkdir $1
        mv *xvg ./$1
        mv *density.log ./$1
}

{ echo 2; echo 2; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $1-density.xvg -relative -sl $num > $1-density.log
{ echo 3; echo 3; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $2-density.xvg -relative -sl $num > $2-density.log
{ echo 4; echo 4; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $7-density.xvg -relative -sl $num > $7-density.log
{ echo 5; echo 5; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $4-density.xvg -relative -sl $num > $4-density.log
{ echo 6; echo 6; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $5-density.xvg -relative -sl $num > $5-density.log
{ echo 0; echo 0; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $name-density.xvg -relative -sl $num > $name-density.log

mover density-$name
cd density-$name
$scriptpath/unxvg2txt.sh '*'
