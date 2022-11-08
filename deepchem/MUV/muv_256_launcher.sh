#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=muv-256-train
#SBATCH --output=muv256_17Mar2022.out
#SBATCH  --time=61:10:00
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 10 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=gol_qsh226_uksr #Account to run under

module purge
module load ccs/singularity 
module load ccs/cuda/11.2.0_460.27.04 

# This script submits a job on the singularity container. In this case it's to
# to train a deep learning  model.

echo "Job $SLURM_JOB_ID running on SLURM NODELIST: $SLURM_NODELIST"
#epoch=${2:-10}
#dataset=${1:-"melting point small.csv"}
singularity run --app deepchem250gpu --nv -B $HOME/.local-dc:$HOME/.local /share/singularity/images/ccs/conda/lcc-conda-1-rocky8.sinf python muv_256_trainer.py
