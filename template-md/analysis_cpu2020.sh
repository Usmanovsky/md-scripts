#!/bin/bash
#SBATCH  --partition=SKY32M192_L
#SBATCH  --job-name=THY-LID11x
#SBATCH --output=thy_lid11x.out
#SBATCH  --time=36:00:00
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
options_md="-ntmpi 8 -npme 4 -nb gpu"

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
