#!/bin/bash
#SBATCH --time=45:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=batch3-dat2out      # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=1                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH -c 128
#SBATCH --mem=256g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-dat2out3-%j.err             # Error file for this job.
#SBATCH -o slurm-dat2out3-%j.out             # Output file for this job.
#SBATCH -A xxx       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user xxx@xxx   # Where email is sent to (optional)

module load Miniconda3
source ~/.bashrc
source activate py310

# This runs a script to convert dssp/dat files to out files
# $1 is the folder path where the out-folders are located.
./submit-dat-to-out.sh "$1"
