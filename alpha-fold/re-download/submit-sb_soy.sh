#!/bin/bash
#SBATCH --time=02:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=soy_out      # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=128                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH --mem=128g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-%j.err             # Error file for this job.
#SBATCH -o slurm-%j.out             # Output file for this job.
#SBATCH -A coa_qsh226_uksr       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user ulab222@uky.edu   # Where email is sent to (optional)

module load Miniconda3
conda init bash
source ~/.bashrc
conda activate py310

./submit-dat-to-out.sh $1
