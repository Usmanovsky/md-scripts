#!/bin/bash
#SBATCH --time=35:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=batch2-pdb2dat      # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=1                  # Number of cores for the job. Same as SBATCH -n 1
#SBATCH -c 128
#SBATCH --mem=256g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-pdb2dat2-%j.err             # Error file for this job.
#SBATCH -o slurm-pdb2dat2-%j.out             # Output file for this job.
#SBATCH -A coa_qsh226_uksr       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user ulab222@uky.edu   # Where email is sent to (optional)

module load Miniconda3
#conda init
#source ~/.bashrc
source activate dssp

# This runs a script to convert dssp/dat files to out files
# $1 is the folder path where the out-folders are located.
~/myscripts/alpha-fold/re-download/dssp-pdb2dat.sh $1
