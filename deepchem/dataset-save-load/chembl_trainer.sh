#!/bin/bash
#SBATCH  --partition=V4V32_SKY32M192_L
#SBATCH  --job-name=chembl-joblib-save
#SBATCH --output=chembl25_savejoblib__13Apr2022.out
#SBATCH  --time=04:00:00
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 8 #No of cores
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
singularity run --app deepchem250gpu --nv -B $HOME/.local-dc:$HOME/.local /share/singularity/images/ccs/conda/lcc-conda-1-rocky8.sinf python *_trainer.py
