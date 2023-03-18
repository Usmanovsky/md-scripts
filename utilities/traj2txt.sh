#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=DL21-AI-traj
#SBATCH --output=dl21_17Dec2020.out
#SBATCH  --time=1:00:00
#SBATCH  --mail-user=xxx@xxx
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 8 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=xxx #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130
module load ccs/conda/python-3.8.0


#source /opt/ohpc/pub/libs/conda/env/python-3.8.0
source /path/to/gromacs2020.4/bin/GMXRC
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

mover(){
	mkdir $1
	mv *xvg ./$1
#	mv *txt ./$1
}

# Trajectory
{ echo 2; echo q; } | gmx_gpu traj -n $name.ndx -f $name$f.trr -s $name$f.tpr -ox $1-$4$t.xvg
{ echo 3; echo q; } | gmx_gpu traj -n $name.ndx -f $name$f.trr -s $name$f.tpr -ox $2-$4$t.xvg
#python3 $SCRATCH/Scripts/xvg2dat.py $name-$t.xvg

mover traj-split
