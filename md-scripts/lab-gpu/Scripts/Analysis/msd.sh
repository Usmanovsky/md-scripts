#!/bin/bash

# Usman Abbas 08/24/2020
# This script calculates msd for a trajectory using 4 different begin and end times. This is supposed to help us get some sort of error estimate.
source /data/ulab222/gromacs2020.2/bin/GMXRC

name=$1-$2$3
one=1
two=2
three=3
c='_boxed'
d='_em'
e='_npt'
f='_md'
m='_msd'


mover(){
	mkdir $1
	mv *$m*xvg ./$1
	mv *$m*txt ./$1
	mv *$m*.log ./$1
}

# MSD
for x in 1 2 3 4
do
	if [ $x == 1 ]
	then
		begin=0
		end=50000
	elif [ $x == 2 ]
        then
                begin=50000
                end=100000
	elif [ $x == 3 ]
        then
                begin=100000
                end=150000
	elif [ $x == 4 ]
        then
                begin=150000
                end=200000
	else
		echo 'Something went wrong with the times'
		exit
	fi
	{ echo 2; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m$x-$1.xvg -b $begin -e $end > $name$m$x-$1.log

	{ echo 3; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m$x-$2.xvg -b $begin -e $end > $name$m$x-$2.log
	python3 ../../script/xvg2dat.py $name$m$x-$1.xvg
	python3 ../../script/xvg2dat.py $name$m$x-$2.xvg
	mover msd-$x

done

