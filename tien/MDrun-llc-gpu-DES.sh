#!/bin/bash

# V.Gazula 1/8/2019
 
#SBATCH -t 72:00:00   				#Time for the job to run 
#SBATCH --job-name=600-200ZW   		   	#Name of the job
#SBATCH -N 1 					#Number of nodes required
#SBATCH -n 4
#SBATCH -c 8 			        	#Number of cores needed for the job
#SBATCH --partition=V4V32_SKY32M192_L 		#Name of the queue
#SBATCH --gres=gpu:4 			        #Number of GPU's

#SBATCH --mail-type ALL				#Send email on start/end
#SBATCH --mail-user mng228@uky.edu		#Where to send email

#SBATCH --account=gol_qsh226_uksr		#Name of account to run under

echo $CUDA_VISIBLE_DEVICES
cd fold-10/600oxyEO-rerun/Z3-EO2-Tf2N/200ZW-200Li/
./MDrun-llc-gpu-DES-run.sh &
cd ../../../../
cd fold-10/600oxyEO-rerun/Z3-EO3-Tf2N/200ZW-200Li/
./MDrun-llc-gpu-DES-run.sh &
cd ../../../../
cd fold-10/600oxyEO-rerun/Z3-EO4-Tf2N/200ZW-200Li/
./MDrun-llc-gpu-DES-run.sh &
cd ../../../../
cd fold-10/600oxyEO-rerun/Z3-EO5-Tf2N/200ZW-200Li/
./MDrun-llc-gpu-DES-run.sh &
cd ../../../../
wait
