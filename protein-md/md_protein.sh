#!/bin/bash
source /path/to/gromacs2022.1/bin/GMXRC
options_md="-ntmpi 1 -ntomp 8 -update gpu -nb gpu"

# This script works on the LCC. It runs a GROMACS md simulation using LibParGen files
# $1 is the protein name, $2 are the gro files,$3 is the molar ratio, $4 is the no of moles of A,
# $5 is the box size and $6 is the radius between molecules of A
# $name$c is the boxed gro file, $name$d is the Energy minimization mdp,
# $name$e is the NPT mdp, $name$f is the production mdp

a=$4

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
neu='_neutral'
s='_sol'
h='hbond'
type1='hac'
dd='dist'
ang='angle'
l='hlife'
n='hnum'


# prepping the protein file
APOE=APOE4
gmx_gpu pdb2gmx -f $name.pdb -p $name$s.top -o $name.gro -ignh -ter
gmx_gpu editconf -d 6.0 -f $name.gro -o $name$c.gro -c
gmx_gpu solvate -cs spc216.gro -cp $name$c.gro -o $name$s.gro -p $name.top -shell 3
gmx_gpu make_ndx -f $name$s.gro -o $name.ndx
gmx_gpu grompp -f $one.mdp -c $name$s.gro -n $name.ndx -p $name.top -o ions.tpr -maxwarn 2
gmx_gpu genion -s ions.tpr -p $name.top -o $name$neu.gro -neutral
gmx_gpu make_ndx -f $name$neu.gro -o $name$neu.ndx

# Energy minimization
gmx_gpu  grompp -f $one.mdp -c $name$neu.gro -p $name.top -o $name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -deffnm $name$d
echo 'EM mdrun done'

# NPT Equilibration
gmx_gpu  grompp -f $two.mdp -c $name$d.gro -p $name.top -o $name$e.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -deffnm $name$e $options_md
echo 'NPT mdrun done'

# Production run
gmx_gpu  grompp -f $three.mdp -c $name$e.gro -p $name.top -o $name$f.tpr
gmx_gpu mdrun -deffnm $name$f $options_md
echo 'MD done'



