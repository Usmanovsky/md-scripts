#!/bin/bash
source /path/to/gromacs2020.4/bin/GMXRC
options_md="-ntmpi 1 -ntomp 8 -update gpu -nb gpu"

# This script works on the LCC. It runs a GROMACS md simulation using LibParGen files
# $1 and $2 are the gro files,$3 is the molar ratio, $4 is the no of moles of A,
# $5 is the box size and $6 is the radius between molecules of A
# $name$c is the boxed gro file, $name$d is the Energy minimization mdp,
# $name$e is the NPT mdp, $name$f is the production mdp

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
t='_traj'

mover(){
	mkdir $1
	mv *xvg ./$1
}

# Putting the gro file into a box 
gmx_gpu insert-molecules -ci $1.gro -o $name.gro -nmol $a -box $5 -radius $6
gmx_gpu insert-molecules -ci $2.gro -f $name.gro -o $name$c.gro -nmol $b
echo 'Gro file boxed'

# Energy minimization
gmx_gpu  grompp -f $name$one.mdp -c $name$c.gro -p $name.top -o $name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -v -s $name$d.tpr -o $name$d.trr -c $name$d.gro -e $name$d.edr -g $name$d.log
echo 'EM mdrun done'

# NPT Equilibration
gmx_gpu  grompp -f $name$two.mdp -c $name$d.gro -p $name.top -o $name$e.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -v -s $name$e.tpr -o $name$e.trr -c $name$e.gro -e $name$e.edr -g $name$e.log $options_md
echo 'NPT mdrun done'

# Production run
gmx_gpu  grompp -f $name$three.mdp -c $name$e.gro -p $name.top -o $name$f.tpr
gmx_gpu mdrun -v -s $name$f -o $name$f.trr -c $name$f.gro -e $name$f.edr -g $name$f.log $options_md
echo 'MD done'


# Making index files
{ echo 'a O* & 2'; echo 'a O* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$t.ndx

# EDR ananlysis
echo "10\n" | gmx_gpu energy -f $name$d.edr -o $name-energymin.xvg
echo "17\n" | gmx_gpu energy -f $name$e.edr -o $name-press.xvg
echo "23\n" | gmx_gpu energy -f $name$e.edr -o $name-density.xvg
mover edr

# Trajectory
{ echo 4; echo q; } | gmx_gpu traj -n $name$t.ndx -f $name$f.trr -s $name$f.tpr -ox $1-$name$t.xvg
{ echo 5; echo q; } | gmx_gpu traj -n $name$t.ndx -f $name$f.trr -s $name$f.tpr -ox $2-$name$t.xvg
mover $name-$t-$o

# MSD
#{ echo 2; } | gmx_gpu msd -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$m-$1.xvg

#{ echo 3; } | gmx_gpu msd -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$m-$2.xvg
#mover msd

# RDF
#{ echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$r-112.xvg
#{ echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$r-22.xvg

#mover rdf

