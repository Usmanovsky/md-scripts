#!/bin/bash


source /data/ulab222/gromacs-2020.4/bin/GMXRC
options_md="-ntmpi 1 -ntomp 8 -update gpu -nb gpu"

# This script works on the LCC. It runs a GROMACS md simulation using LibParGen files
# $1 and $2 are the gro files,$3 is the molar ratio, $4 is the no of moles of A,
# $5 is the box size and $6 is the radius between molecules of A
# $name$c is the boxed gro file, $name$d is the Energy minimization mdp,
# $name$e is the NPT mdp, $name$f is the production mdp

name=$1-$2$3
one=1
two=2
three=3
c='_boxed'
d='_em'
e='_npt'
f='_md'
m='_msd'
r='_rdf'
t='traj'
o='oxygen'

mover(){
	mkdir $1
	mv *xvg ./$1
	mv *$t*ndx ./$1
}

# Making index files
{ echo 'a O* & 2'; echo 'a O* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$t.ndx

# Trajectory
{ echo 4; echo q; } | gmx_gpu traj -n $name$t.ndx -f $name$f.trr -s $name$f.tpr -ox $1-$4$t.xvg
{ echo 5; echo q; } | gmx_gpu traj -n $name$t.ndx -f $name$f.trr -s $name$f.tpr -ox $2-$4$t.xvg

mover $name-$t-$o
