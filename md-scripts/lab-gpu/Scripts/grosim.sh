#!/bin/bash
# This script runs a GROMACS md simulation

source /usr/local/gromacs/bin/GMXRC

gmx pdb2gmx -f $1.pdb -o $1.gro -water none
echo 'Gro file produced'

# Putting the gro file into a box 
gmx editconf -f $1.gro -o $1_boxed.gro -c -d 1.0 -bt cubic
echo 'Gro file boxed'

# Energy minimization
gmx  grompp -f $2.mdp -c $1_boxed.gro -p $3.top -o $1_em.tpr
echo 'EM grompp done'
gmx mdrun -v -s $1_em -o $1_em.trr -c $1_em.gro -e $1_em.edr -g $1_em.log
echo 'EM mdrun done'
gmx energy -f $1_em.edr -o energymin.xvg
echo 'EM plot done'
# NPT Equilibration
gmx  grompp -f $3.mdp -c $1_em.gro -p $3.top -o $1_npt.tpr
echo 'NPT grompp done'
gmx mdrun -v -s $1_npt -o $1_npt.trr -c $1_npt.gro -e $1_npt.edr -g $1_npt.log
echo 'NPT mdrun done'
gmx energy -f $1_npt.edr -o $1_pressure.xvg
echo 'NPT pressure plot done'
gmx energy -f $1_npt.edr -o $1_density.xvg
echo 'NPT density plot done'

# Production run
gmx  grompp -f $4.mdp -c $1_npt.gro -p $3.top -o $1_md.tpr
gmx mdrun -v -s $1_md -o $1_md.trr -c $1_md.gro -e $1_md.edr -g $1_md.log
echo 'MD done'
