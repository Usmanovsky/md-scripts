#!/bin/bash

# This script works on our local GPUs. It runs a GROMACS md simulation using LibParGen files
# $1 and $2 are the gro files, $name is the boxed gro file, $name1 is the Energy minimizationmisation mdp,
# $name2 is the NPT mdp, $name3 is the production mdp

read -p 'GROMACS Version (last digit): ' version

if [ $version == 1 ] || [ $version == 2 ]
then
	source /path/to/gromacs2020.$version/bin/GMXRC
elif [ $version == 1 ]
then
	source /path/to/gromacs-2020.$version/bin/GMXRC
else
	echo "You shall not pass. GROMACS version in path isn't correct. Goodbye. "
exit
fi

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

mover(){
	mkdir $1
	mv *xvg ./$1
}

# Putting the gro file into a box 
gmx_gpu insert-molecules -ci $1.gro -o $name.gro -nmol $a -box $5 -radius $6
gmx_gpu insert-molecules -ci $2.gro -f $name.gro -o $name$c.gro -nmol $b
echo 'Gro file boxed'

# Energy minimization
gmx_gpu  grompp -f $name1.mdp -c $name$c.gro -p $name.top -o $name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -v -s $name_em.tpr -o $name_em.trr -c $name_em.gro -e $name_em.edr -g $name_em.log $options_md
echo 'EM mdrun done'

# NPT Equilibration
gmx_gpu  grompp -f $name2.mdp -c $name_em.gro -p $name.top -o $name_npt.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -v -s $name_npt.tpr -o $name_npt.trr -c $name_npt.gro -e $name_npt.edr -g $name_npt.log $options_md
echo 'NPT mdrun done'

# Production run
gmx_gpu  grompp -f $name3.mdp -c $name_npt.gro -p $name.top -o $name_md.tpr
gmx_gpu mdrun -v -s $name_md -o $name_md.trr -c $name_md.gro -e $name_md.edr -g $name_md.log $options_md
echo 'MD done'


# Making index files
if [ $2 == 'Lid' ]
then
	{ echo 'a C* & 2'; echo 'a O* & 2';  echo 'a H* & 2'; echo 'a C* & 3'; echo 'a O* & 3'; echo 'a H* & 3'; echo 'a N* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx
else
	{ echo 'a C* & 2'; echo 'a O* & 2';  echo 'a H* & 2'; echo 'a C* & 3'; echo 'a O* & 3'; echo 'a H* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx
fi

# EDR ananlysis
echo "10\n" | gmx_gpu energy -f $name$d.edr -o $name-energymin.xvg
echo "17\n" | gmx_gpu energy -f $name$e.edr -o $name-press.xvg
echo "23\n" | gmx_gpu energy -f $name$e.edr -o $name-density.xvg
mover edr

# MSD
{ echo 2; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$1.xvg

{ echo 3; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$2.xvg
mover msd

# RDF
if [ $2 == 'Lid' ]
then
	{ echo 4; echo 7; echo 8; echo 9; echo 10; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$r.xvg

else
	{ echo 4; echo 7; echo 8; echo 9; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$r.xvg
fi
mover rdf
