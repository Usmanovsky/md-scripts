#!/bin/bash

# This script works on our local GPUs. It runs a GROMACS md simulation using LibParGen files
# $1 and $2 are the gro files, $3 is the molar ratio $4 is the version number of GROMACAS,
# $5 is the number of molecules of compound a. 
# $name is the boxed gro file, $name1 is the Energy minimizationmisation mdp,
# $name2 is the NPT mdp, $name3 is the production mdp

read -p 'GROMACS Version (last digit): ' version

if [ $version == 1 ] || [ $version == 2 ]
then
	source /data/ulab222/gromacs2020.$version/bin/GMXRC
elif [ $version == 1 ]
then
	source /data/ulab222/gromacs-2020.$version/bin/GMXRC
else
	echo "You shall not pass. GROMACS version in path isn't correct. Goodbye. "
exit
fi

options_md="-ntmpi 8 -npme 4"


# For this script you do not need to inout $5. It's there for my pleasure...
#a=$5

#if [ $3 == 11 ]
#then
#	b=$a
#elif [ $3 == 12 ]
#then
#	b=$(( $a * 2 ))
#elif [ $3 == 21 ]
#then
#	b=$(( $a / 2 ))
#else
#	echo "I am lost"
#	exit
#fi

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

mover(){
	mkdir $1
	mv *xvg ./$1
}

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


