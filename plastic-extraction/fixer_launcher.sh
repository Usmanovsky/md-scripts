#!/bin/bash
#SBATCH  --partition=P4V12_SKY32M192_L
#SBATCH  --job-name=dm11-petwat_corrected
#SBATCH --output=corrected-dm11-petwat_21Oct2021.out
#SBATCH  --time=55:10:00
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

#source /path/to/gromacs2021.2/bin/GMXRC

# This script shifts molecules in a box along the z axis. $4 is the length to shift.
# This assumes all your files are in the same working directory.

python3 deswater_fixer*py $1 $2 $3
./gro_renum-lcc.sh $4
