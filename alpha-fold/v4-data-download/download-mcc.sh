#!/bin/bash

# V.Gazula 1/8/2019
 
#SBATCH -t 144:00:00   				#Time for the job to run 
#SBATCH --job-name=batch5		   	#Name of the job
#SBATCH -N 1 					#Number of nodes required
#SBATCH -n 128					#Number of cores needed for the job
#SBATCH --partition=normal  		#Name of the queue

#SBATCH --mail-type ALL				#Send email on start/end
#SBATCH --mail-user  xxx@xxx		#Where to send email

#SBATCH --account=xxx		#Name of account to run under

# This downlaods all the pdb files in the csv file ($1) from AF DB
xargs -n 1 -P 512 wget < $1

