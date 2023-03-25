#!/bin/bash
#SBATCH --time=24:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=fairlearn_total_csv      # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=128                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH --mem=256g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-fairlearn-%j.err             # Error file for this job.
#SBATCH -o slurm-fairlearn-%j.out             # Output file for this job.
#SBATCH -A xxx       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user xxx@xxx   # Where email is sent to (optional)

module load Miniconda3
conda init
source ~/.bashrc
conda activate fairlearn
#conda list

python3 flearn.py $1
