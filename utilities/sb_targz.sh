#!/bin/bash
#SBATCH --time=55:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=comp-tar      # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=1                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH -c 128
#SBATCH --mem=128g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-v4-batch-updated-accessions-%j.err             # Error file for this job.
#SBATCH -o slurm-v4-batch-updated-accessions-%j.out             # Output file for this job.
#SBATCH -A coa_qsh226_uksr       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user ulab222@uky.edu   # Where email is sent to (optional)

#module load Miniconda3
#conda init
source ~/.bashrc
#source activate py310

# This runs a script to sample batches 2-5 based on proteins not in batch 1.
#tar -zcvf  /scratch/ulab222/alpha-fold/batches-dssp.tgz /scratch/ulab222/alpha-fold/batches-dssp/ #> /scratch/ulab222/alpha-fold/batchesdssp.log

#tar -zcvf  /scratch/ulab222/alpha-fold/complete-v4-batches.tgz /scratch/ulab222/alpha-fold/complete-v4-batches/ #> /scratch/ulab222/alpha-fold/complete-v4-batches.log

tar -zcvf  /scratch/ulab222/alpha-fold/v4-batch-updated-accessions.tgz /scratch/ulab222/alpha-fold/v4-batch-updated-accessions/ # > /scratch/ulab222/alpha-fold/v4-batch-updated-accessions.log
