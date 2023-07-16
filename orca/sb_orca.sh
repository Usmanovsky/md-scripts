#!/bin/bash
#SBATCH --time=7-35:15:00             # Time limit for the job (REQUIRED).
#SBATCH --job-name=6jxt16-D4-b3lyp-OPT    # Job name
#SBATCH --nodes=1               # Number of nodes to allocate. Same as SBATCH -N (Don't use this option for mpi jobs)
#SBATCH --ntasks=32                  # Number of cores for the job. Same as SBATCH -n 1
##SBATCH -c 32
#SBATCH --mem=0g
#SBATCH --partition=normal          # Partition/queue to run the job in. (REQUIRED)
#SBATCH -e slurm-6jxt16-D4-b3lyp-OPT-%j.err             # Error file for this job.
#SBATCH -o slurm-6jxt16-D4-b3lyp-OPT-%j.out             # Output file for this job.
#SBATCH -A coa_qsh226_uksr       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user ulab222@uky.edu   # Where email is sent to (optional)

module load openmpi-4.1.1-gcc-9.3.0-zhqxeh5
source .bash_profile
#source ~/.bashrc

#populate the node list
scontrol show hostnames $SLURM_JOB_NODELIST > parent_salen.nodes

# $1 is the orca .inp file
#shifter /pscratch/sd/u/ulab/orca/orca $1
/project/qsh226_uksr/ulab/orca/orca $1

