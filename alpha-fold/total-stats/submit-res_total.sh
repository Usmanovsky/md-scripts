#!/bin/bash
#SBATCH --time=10:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=res1_total_boxplot      # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=1                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH -c 64
#SBATCH --mem=128g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-res1total-%j.err             # Error file for this job.
#SBATCH -o slurm-res1total-%j.out             # Output file for this job.
#SBATCH -A xxx       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user xxx@xxx   # Where email is sent to (optional)

module load Miniconda3
#conda init
source ~/.bashrc
source activate py310

# This generates a total-res$1.csv file
# and then generates a stat-res_10_90.boxplot file
# $1 is the batch number

./dat-merger_total.sh $1
./stat-res_total.sh
