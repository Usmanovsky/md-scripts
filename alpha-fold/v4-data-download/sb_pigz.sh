#!/bin/bash
#SBATCH --time=14-00:00:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=batch2-pigz      # Job name
##SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=256                  # Number of cores for the job. Same as SBATCH -n 1
##SBATCH -c 128
#SBATCH --mem=400g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-batch2-dssp-pigz-%j.err             # Error file for this job.
#SBATCH -o slurm-batch2-dssp-pigz-%j.out             # Output file for this job.
#SBATCH -A xxx       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user xxx@xxx   # Where email is sent to (optional)

source ~/.bashrc

# This runs a script to compress folders using tar and pigz.
input=$1
output=${2:-$input.tar.gz}

#tar --use-compress-program="pigz -k " -cf /path/to/alpha-fold/batches-dssp.tar.gz /path/to/alpha-fold/batches-dssp/

#tar --use-compress-program="pigz -k " -cf /path/to/alpha-fold/complete-v4-batches.tar.gz /path/to/alpha-fold/complete-v4-batches/ 

#tar --use-compress-program="pigz -k " -cf /path/to/alpha-fold/v4-batch-updated-accessions.tar.gz /path/to/alpha-fold/v4-batch-updated-accessions/

tar --use-compress-program="pigz -k " -cvf $output $input
