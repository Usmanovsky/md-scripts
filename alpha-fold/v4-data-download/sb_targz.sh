#!/bin/bash
#SBATCH --time=14-00:00:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=dssp1-tar      # Job name
##SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=256                  # Number of cores for the job. Same as SBATCH -n 1
##SBATCH -c 128
#SBATCH --mem=400g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-batch1-dssp-%j.err             # Error file for this job.
#SBATCH -o slurm-batch1-dssp-%j.out             # Output file for this job.
#SBATCH -A xxx       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user xxx@xxx   # Where email is sent to (optional)

#module load Miniconda3
#conda init
source ~/.bashrc
#source activate py310

# This runs a script to compress folders into one tar or tgz file.
input=$1
output=${2:-$input.tgz}

#tar -zcvf  /path/to/alpha-fold/batches-dssp.tgz /path/to/alpha-fold/batches-dssp/ #> /path/to/alpha-fold/batchesdssp.log

#tar -zcvf  /path/to/alpha-fold/complete-v4-batches.tgz /path/to/alpha-fold/complete-v4-batches/ #> /path/to/alpha-fold/complete-v4-batches.log

# tar -zcvf  /path/to/alpha-fold/v4-batch-updated-accessions.tgz /path/to/alpha-fold/v4-batch-updated-accessions/ # > /path/to/alpha-fold/v4-batch-updated-accessions.log

tar -zcvf $output $input
