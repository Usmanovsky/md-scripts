#!/bin/bash
#SBATCH  --partition=V4V32_SKY32M192_L
#SBATCH  --job-name=DEA-MEN11XX
#SBATCH --output=dea_men11XX.out
#SBATCH  --time=3-00:00:00
#SBATCH  --mail-user=xxx@xxx
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 8 #No of cores
#SBATCH --gres=gpu:2 #no of gpu
#SBATCH --account=xxx #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130

source /path/to/gromacs2020/bin/GMXRC
options_md="-ntmpi 8 -npme 4 -nb gpu"

# This script runs a GROMACS md simulation using LibParGen files
# $1 and $2 are the gro files, $3 is the boxed gro file, $4 is the Energy minmisation mdp,
# $5 is the NPT mdp, $6 is the production mdp

# Production run
gmx_gpu convert-tpr -s $3_md2.tpr -nsteps 100000000 -o $3_md2.tpr
gmx_gpu mdrun -v -s $3_md2 -o $3_md.trr -c $3_md.gro -e $3_md.edr -g $3_md.log $options_md
echo 'MD done'
