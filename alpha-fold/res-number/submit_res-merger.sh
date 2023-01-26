#!/bin/bash
#SBATCH --time=15:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=res_merger_batch5      # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=64                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH --mem=128g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-batch5-%j.err             # Error file for this job.
#SBATCH -o slurm-batch5-%j.out             # Output file for this job.
#SBATCH -A coa_qsh226_uksr       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user ulab222@uky.edu   # Where email is sent to (optional)

module load Miniconda3
conda init bash
conda activate py310

./mk-folders.sh
./res-merger.sh $1
