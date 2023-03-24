#!/bin/bash

# V.Gazula 1/8/2019
 
#SBATCH -t 144:00:00   				#Time for the job to run 
#SBATCH --job-name=batch5		   	#Name of the job
#SBATCH -N 1 					#Number of nodes required
#SBATCH -n 20					#Number of cores needed for the job
#SBATCH --partition=normal  		#Name of the queue
##SBATCH --partition=jumbo  		#Name of the queue

#SBATCH --mail-type ALL				#Send email on start/end
#SBATCH --mail-user  qsh226@uky.edu		#Where to send email

#SBATCH --account=coa_qsh226_uksr		#Name of account to run under


#xargs -n 1 -P 128 wget < url-batch2.csv
module load ccs/conda/python 
#conda init bash
conda activate /project/qsh226_uksr/qsh226/dssp 


for i in {1..20}
do
{
cp do-dssp-mcc-folder.sh folder-$i/
cd folder-$i
nohup ./do-dssp-mcc-folder.sh & 
cd ..
}
done


