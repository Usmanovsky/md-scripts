#!/bin/bash
#Written by ULAB 01/10/2023
#SBATCH --partition=V4V32_CAS40M192_L			#Name of the partition
#SBATCH --job-name multiview-xxx			#Nameof the job
#SBATCH --output slurm-simclr-%j.out                #Output file name
#SBATCH -e slurm-simclr-%j.err                      #error file name
#SBATCH --account=gol_qsh226_uksr 			#SLurm Account
#SBATCH --ntasks=30					#Number of cores
#SBATCH --gres=gpu:2					#Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user ulab222@uky.edu			#Email to forward
#SBATCH --time=48:00:00					#Time required for the Jupyter job

module load ccs/cuda/11.2.0_460.27.04
module load ccs/Miniconda3
conda init
source ~/.bashrc
conda activate pytorch
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/ulab222/.conda/envs/pytorch/lib/python3.10/site-packages/nvidia/cublas/lib:$LD_LIBRARY_PATH

#module load ccs/cuda/11.2.0_460.27.04
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ohpc/pub/utils/ccs/cuda/10.1.105/toolkit/targets/x86_64-linux/lib/
#module load ccs/Miniconda3
#conda init
#source ~/.bashrc
#conda activate pytorch

# This trains a SimCLR model. Batch size is $1
# Use batch 32 for res50. batch 128 for res18.
python3 ./simCLR_contactmap_seq-v4.py -b $1 --epochs 50 --max_length 500 --log-every-n-steps 2000
