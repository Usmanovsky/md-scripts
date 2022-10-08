#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=chcl-ml21_300
#SBATCH --output=ChClMl21_18Jun2021.out
#SBATCH  --time=35:10:00
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 10 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=gol_qsh226_uksr #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130
module load ccs/conda/python-3.8.0

#source /project/qsh226_uksr/DES_usman/gromacs2021.2/bin/GMXRC

# This script shifts molecules in a box along the z axis. $4 is the length to shift.
# This assumes all your files are in the same working directory.

python3 gro_merger*py $1 $2 .
./des_des-lcc.sh $3
