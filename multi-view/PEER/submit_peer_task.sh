#!/bin/bash
#Written by ULAB 02/24/2022
#SBATCH --partition=V4V32_CAS40M192_L			#Name of the partition
#SBATCH --job-name multiview-peer			#Nameof the job
#SBATCH --output slurm-peer-%j.out                #Output file name
#SBATCH -e slurm-peer-%j.err                      #error file name
#SBATCH --account=gol_qsh226_uksr 			#SLurm Account
#SBATCH --ntasks=32					#Number of cores
#SBATCH --gres=gpu:4					#Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user ulab222@uky.edu			#Email to forward
#SBATCH --time=40:00:00					#Time required for the Jupyter job

module load ccs/cuda/11.2.0_460.27.04
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ohpc/pub/utils/ccs/cuda/10.1.105/toolkit/targets/x86_64-linux/lib/
module load ccs/Miniconda3
conda init
source ~/.bashrc
conda activate protein
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/ulab222/.conda/envs/pytorch/lib/python3.10/site-packages/nvidia/cublas/lib:$LD_LIBRARY_PATH

# This tests simCLR on PEER benchmark
python3 script/run_single_ESM_beta.py -c ./PEER_Benchmark/config/single_task/ESM/stability_ESM_fix.yaml --seed 0
load model
#python3 simCLR_contactmap_seq-v7.py -a resnet50 -b 32 --epochs 100 --max_length 500 --lr 0.0005 --load 0 --fp16-precision --temperature 0.05 --out_dim 196
