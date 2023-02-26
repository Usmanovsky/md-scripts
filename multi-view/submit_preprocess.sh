#!/bin/bash
#Written by ULAB 01/10/2023
#SBATCH --partition=V4V32_CAS40M192_L			#Name of the partition
#SBATCH --job-name multiview-xxx			#Nameof the job
#SBATCH --output slurm-preprocess-%j.out                #Output file name
#SBATCH -e slurm-preprocess-%j.err                      #error file name
#SBATCH --account=xxx 			#SLurm Account
#SBATCH --ntasks=10					#Number of cores
#SBATCH --gres=gpu:1					#Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user xxx@xxx			#Email to forward
#SBATCH --time=48:00:00					#Time required for the Jupyter job

module load ccs/cuda/11.2.0_460.27.04
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ohpc/pub/utils/ccs/cuda/10.1.105/toolkit/targets/x86_64-linux/lib/
module load ccs/Miniconda3
conda init
source ~/.bashrc
conda activate pytorch

# This generates contact map and one-hot encoding for proteins in $1
python3 ~/MultiViewProtein/preprocess.py -data $1 -max_len 500
