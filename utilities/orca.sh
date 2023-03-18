#!/bin/bash

#Written by VG /4/3/2019


#SBATCH --partition=P4V12_SKY32M192_D			#Name of the partition
#SBATCH --job-name jupyter-notebook			#Nameof the job
#SBATCH --output jupyter-notebook-%J.log                #Output file name
#SBATCH --account=gol_griff_uksr 			#SLurm Account
#SBATCH --ntasks=1					#Number of cores
#SBATCH --gres=gpu:1					#Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user gazula@uky.edu			#Email to forward
#SBATCH --time=00:05:00					#Time required for the Jupyter job


## get tunneling info
XDG_RUNTIME_DIR=""
ipnport=$(shuf -i8000-9999 -n1)
ipnip=$(hostname -i)

user=$(whoami) 
tokenccs=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1)


## print tunneling instructions to jupyter-log-{jobid}.txt
echo -e "
    Copy/Paste this in your local terminal to ssh tunnel with remote
    -----------------------------------------------------------------
    ssh -L $ipnport:$ipnip:$ipnport $user@128.163.15.13
    -----------------------------------------------------------------

    Then open a browser on your local machine to the following address
    ------------------------------------------------------------------
    localhost:$ipnport/?token=$tokenccs  (prefix w/ https:// if using password)
    ------------------------------------------------------------------
    "  > jupyter.creds.out

EMAIL_ADDRESS=$(cat /home/$USER/.forward)
EMAIL_BODY=$PWD/jupyter.creds.out
#SSH_TO="ssh $USER@lcc.ccs.uky.edu ' mail -s 'Jupiter_Notebook_login_details' $EMAIL_ADDRESS < $EMAIL_BODY' "
#eval $SSH_TO

mail -S smtp=lcc.localdomain -s 'Jupiter_Notebook_login_details'  $EMAIL_ADDRESS < $EMAIL_BODY


module load ccs/singularity
mkdir -p /scratch/$USER/jupyter.tmp
srun singularity run --nv -B /scratch/$USER/jupyter.tmp:/tf -B /scratch/$USER/jupyter.tmp:/run/notebook /share/singularity/images/ccs/TensorFlow/tf-jupyter-gpu/tf-keras-jupyter-gpu.sinf jupyter notebook --notebook-dir=/scratch/$USER  --no-browser --port=$ipnport --ip=$ipnip --NotebookApp.token=$tokenccs
