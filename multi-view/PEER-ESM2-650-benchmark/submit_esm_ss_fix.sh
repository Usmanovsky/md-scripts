#!/bin/bash
#Written by ULAB 05/20/2023
#SBATCH --partition=V4V32_SKY32M192_L #V4V32_CAS40M192_L			#Name of the partition
#SBATCH --job-name seed0ssFIXEsm2-650M			#Nameof the job
#SBATCH --output slurm-ssFIX-esm2-650-seed0-%j.out                #Output file name
#SBATCH -e slurm-ssFIX-esm2-650-seed0-%j.err                      #error file name
#SBATCH --account=gcl_qsh226_uksr 			#SLurm Account
#SBATCH -N 1
#SBATCH --ntasks=1					#Number of cores
#SBATCH -c 32
#SBATCH --gres=gpu:1					#Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user ulab222@uky.edu			#Email to forward
#SBATCH --time=72:00:00					#Time required for the J_v2.pyter job

module load ccs/cuda/11.2.0_460.27.04
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ohpc/pub/utils/cuda/10.1.115/toolkit/targets/x86_64-linux/lib/
module load ccs/Miniconda3
source ~/.bashrc
source activate protein
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

# This tests simCLR on PEER benchmark
python3 -m torch.distributed.launch --nproc_per_node=1 script/run_single.py -c ./config/single_task/ESM/ss_ESM_fix.yaml --seed 0
