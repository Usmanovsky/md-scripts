#!/bin/bash

# V.Gazula 1/8/2019
 
#SBATCH -t 144:00:00   				#Time for the job to run 
#SBATCH --job-name=batch5		   	#Name of the job
#SBATCH -N 1 					#Number of nodes required
#SBATCH -n 128					#Number of cores needed for the job
#SBATCH --partition=normal  		#Name of the queue

#SBATCH --mail-type ALL				#Send email on start/end
#SBATCH --mail-user  qsh226@uky.edu		#Where to send email

#SBATCH --account=coa_qsh226_uksr		#Name of account to run under


xargs -n 1 -P 512 wget < url-batch5.csv

