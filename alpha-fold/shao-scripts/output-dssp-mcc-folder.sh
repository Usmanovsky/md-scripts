#!/bin/bash

#SBATCH -t 10:00:00                            #Time for the job to run
#SBATCH --job-name=ds-b2                  #Name of the job
#SBATCH -N 1                                    #Number of nodes required
#SBATCH -n 1                                   #Number of cores needed for the job
#SBATCH --partition=normal              #Name of the queue
##SBATCH --partition=jumbo              #Name of the queue

#SBATCH --mail-type ALL                         #Send email on start/end
#SBATCH --mail-user  xsh230@uky.edu             #Where to send email

#SBATCH --account=xxx               #Name of account to run under


module load ccs/conda/python 
#conda activate /path/to/qsh226/dssp 

for file in *.pdb
do
{
name=${file%.*}
#echo $name
#mkdssp -i $file -o $name.dssp
python organize-data-ss.py $name
}
done


