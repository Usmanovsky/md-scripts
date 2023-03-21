#!/bin/bash

# ulab 03/13/2023

#SBATCH -t 80:00:00                             #Time for the job to run
#SBATCH --job-name=batch1-dwnld                      #Name of the job
#SBATCH -N 1                                    #Number of nodes required
#SBATCH -c 128                                  #Number of cores needed for the job
#SBATCH --partition=normal              #Name of the queue
#SBATCH --mem=128g
#SBATCH --mail-type ALL                         #Send email on start/end
#SBATCH --mail-user  xxx@xxx            #Where to send email
#SBATCH --account=xxx               #Name of account to run under
#SBATCH -e slurm-dwnld1-%j.err             # Error file for this job.
#SBATCH -o slurm-dwnld1-%j.out             # Output file for this job.


# This downloads all the pdb files in the csv file ($1) from AF DB
xargs -n 1 -P 1000 wget < $1

