#!/bin/bash
#SBATCH  --partition=SKY32M192_L
#SBATCH  --job-name=THY-LID21x
#SBATCH --output=thy_lid21x.out
#SBATCH  --time=330:00:00
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 32 #No of cores
#SBATCH --account=col_qsh226_uksr #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130

source /project/qsh226_uksr/gromacs2020/bin/GMXRC
#source /project/qsh226_uksr/gromacs-2020-CPU/gromacs-exe/bin/GMXRC
options_md="-ntmpi 8 -npme 4"

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

# Putting the gro file into a box 
gmx_gpu insert-molecules -ci $1.gro -o $name.gro -nmol $a -box $5 -radius $6
gmx_gpu insert-molecules -ci $2.gro -f $name.gro -o $name$c.gro -nmol $b
echo 'Gro file boxed'

# Energy minimization
gmx_gpu  grompp -f $name$one.mdp -c $name$c.gro -p $name.top -o $name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -v -s $name$d.tpr -o $name$d.trr -c $name$d.gro -e $name$d.edr -g $name$d.log $options_md
echo 'EM mdrun done'
echo "9\n" | gmx_gpu energy -f $name$d.edr -o energymin.xvg
echo 'EM plot done'

# NPT Equilibration
gmx_gpu  grompp -f $name$two.mdp -c $name$d.gro -p $name.top -o $name$e.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -v -s $name$e.tpr -o $name$e.trr -c $name$e.gro -e $name$e.edr -g $name$e.log $options_md
echo 'NPT mdrun done'
echo "16\n" | gmx_gpu energy -f $name$e.edr -o $name$e.xvg
echo 'NPT pressure plot done'
echo "21\n" | gmx_gpu energy -f $name$e.edr -o $name_density.xvg
echo 'NPT density plot done'

# Production run
gmx_gpu  grompp -f $name$three.mdp -c $name$e.gro -p $name.top -o $name$f.tpr
gmx_gpu mdrun -v -s $name$f -o $name$f.trr -c $name$f.gro -e $name$f.edr -g $name$f.log $options_md
echo 'MD done'

# Analysis
# Making index files
{ echo 2; echo 3; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx

# MSD
{ echo 4; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$1.xvg

{ echo 5; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$2.xvg

# RDF
{ echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$r-$1$2.xvg

{ echo 4; echo 4; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $r-$1-$1.xvg
{ echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $r-$2-$2.xvg

# House Cleaning
mkdir xvg
mv *xvg ./xvg
