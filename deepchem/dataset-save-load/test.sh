#!/bin/bash
#SBATCH  --partition=P4V12_SKY32M192_D
#SBATCH  --job-name=slurm-test
#SBATCH -t 00:10:00
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 8 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=gol_qsh226_uksr #Account to run under
#SBATCH --output=chembl25_csv_${date=`date +%D`}.out

echo ${date=`date +%D`}
