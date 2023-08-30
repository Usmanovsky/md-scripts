#!/bin/bash
#Written by ULAB 02/24/2022
#SBATCH --partition=V4V32_CAS40M192_L			#Name of the partition
#SBATCH --job-name ppi-1gpu			#Nameof the job
#SBATCH --output slurm-ppi1g-%j.out                #Output file name
#SBATCH -e slurm-ppi1g-%j.err                      #error file name
#SBATCH --account=gcl_qsh226_uksr 			#SLurm Account
#SBATCH -N 1
#SBATCH -n 1					#Number of cores
#SBATCH -c 20
#SBATCH --gres=gpu:1					#Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user xxx@xxx			#Email to forward
#SBATCH --time=72:00:00					#Time required for the Jupyter job

module load ccs/cuda/11.2.0_460.27.04
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ohpc/pub/utils/ccs/cuda/10.1.115/toolkit/targets/x86_64-linux/lib/
module load ccs/Miniconda3
source ~/.bashrc
source activate protein
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/ulab222/.conda/envs/pytorch/lib/python3.10/site-packages/nvidia/cublas/lib:$LD_LIBRARY_PATH

# This tests simCLR on PEER benchmark
python3 -m torch.distributed.launch --nproc_per_node=1 script-peer/run_single_ESM_ppi.py -c ./config/single_task/ESM/human_ESM.yaml --seed 0
