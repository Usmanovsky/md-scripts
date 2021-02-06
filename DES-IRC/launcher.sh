#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=batch-DES
#SBATCH --output=batchDES_18Jan2021.out
#SBATCH  --time=70:00:00
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 8 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=gol_qsh226_uksr #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130
module load ccs/conda/python-3.8.0
source /opt/ohpc/pub/libs/conda/env/python-3.8.0

python3 des_irc.py './*'

