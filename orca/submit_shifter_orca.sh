#!/bin/bash
#SBATCH --image=docker:usmanovsky/orca:5.0
#SBATCH --qos=regular
#SBATCH --time=12:00:00
#SBATCH -N 1
#SBATCH -n 32
#SBATCH -C cpu
##SBATCH --mem=0g
#SBATCH --job-name=xxxx-32-SVP      # Job name
#SBATCH -e slurm-xxxx-32-SVP-D4-b3lyp-%j.err             # Error file for this job.
#SBATCH -o slurm-xxxx-32-SVP-D4-b3lyp-%j.out             # Output file for this job.
#SBATCH -A m2878       # Project allocation account name (REQUIRED)
#SBATCH --mail-type ALL         # Send email when job starts/ends
#SBATCH --mail-user xxx@xxx   # Where email is sent to (optional)

#module load Miniconda3
#conda init bash
#source .bash_profile
#source ~/.bashrc

#populate the node list
scontrol show hostnames $SLURM_JOB_NODELIST > parent_salen.nodes

# $1 is the orca .inp file
#shifter /pscratch/sd/u/ulab/orca/orca $1
shifter /global/common/software/m2878/orca/orca $1

