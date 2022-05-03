#!/bin/bash
#SBATCH  --partition=SKY32M192_M
#SBATCH  --job-name=DES
#SBATCH --output=testingcpu.out
#SBATCH  --time=00:05:00
#SBATCH  --mail-user=xxx@xxx
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 32 #No of cores
#SBATCH --account=xxx #Account to run under

# This script runs a GROMACS md simulation
# $1 is the pdb file, $2 is the Energy minmisation mdp, $3 is the topology, 
# $4 is the NPT mdp, $5 is the production mdp

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0

source /path/to/gromacs-2020-CPU/gromacs-exe/bin/GMXRC
options_md="-ntmpi 8 -npme 4 -nb gpu"

gmx pdb2gmx -f $1.pdb -o $1.gro -water none -ff oplsaa
echo 'Gro file produced'

