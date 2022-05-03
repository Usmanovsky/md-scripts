#!/bin/bash

# This script works on our local GPUs. It runs a GROMACS md simulation using LibParGen files
# $1 and $2 are the gro files, $name is the boxed gro file, $name1 is the Energy minimizationmisation mdp,
# $name2 is the NPT mdp, $name3 is the production mdp

source /path/to/gromacs-2020.1/bin/GMXRC
options_md="-ntmpi 8 -npme 4"

a=$4

if [ $3 == 11 ]
then
	b=$a
elif [ $3 == 12 ]
then
	b=$(( $a * 2 ))
elif [ $3 == 21 ]
then
	b=$(( $a / 2 ))
else
	echo "I am lost"
	exit
fi

name=$1-$2-$3
one=1
two=2
three=3
c='_boxed'
d='_em'
e='_npt'
f='_md'
m='_msd'
r='_rdf'

# Making index files
gmx_gpu make_ndx -f $name$c.gro -o $name.ndx

# MSD
gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$1.xvg
gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$2.xvg
# RDF
gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$r.xvg

