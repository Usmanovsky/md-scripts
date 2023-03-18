#!/bin/bash

#Written by ULAB 3/30/2022
#SBATCH --partition=V4V32_CAS40M192_L                   #Name of the partition
#SBATCH --job-name pyemma-jupyter-notebook                    #Nameof the job
#SBATCH --output jupyter-notebook-%j-pyemma.log                #Output file name
#SBATCH --account=gcl_qsh226_uksr                       #SLurm Account
#SBATCH --ntasks=20                                     #Number of cores
#SBATCH --gres=gpu:1                                    #Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user xxx@xxx                     #Email to forward
#SBATCH --time=72:00:00                                 #Time required for the Jupyter job


## get tunneling info
XDG_RUNTIME_DIR=""
ipnport=$(shuf -i8000-9999 -n1)
ipnip=$(hostname -i)

user=$(whoami)
tokenccs=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1)
mountdir=/path/to/DES-IRC
envname='sklearn'
homedir=${2:-$mountdir}  # where to mount the jupyter notebook
envnote=${3:-$envname}   # conda env to load the jupyter notebook
echo $homedir
echo $envnote
## print tunneling instructions to jupyter-log-{jobid}.txt
# replace 47 with 46 or 45 or 43
echo -e "
    Copy/Paste this in your local terminal to ssh tunnel with remote
    -----------------------------------------------------------------
    ssh -L $ipnport:$ipnip:$ipnport $user@10.33.41.46
    -----------------------------------------------------------------

    Then open a browser on your local machine to the following address
    ------------------------------------------------------------------
    localhost:$ipnport/?token=$tokenccs  (prefix w/ https:// if using password)
    ------------------------------------------------------------------
    "  > jupyter_$envnote.creds-$SLURM_JOB_ID-$DATE.out

EMAIL_ADDRESS=$(cat /home/$USER/.forward)
EMAIL_BODY=$PWD/jupyter_$envnote.creds-$SLURM_JOB_ID-$DATE.out
#SSH_TO="ssh $USER@lcc.ccs.uky.edu ' mail -s 'Jupiter_Notebook_login_details' $EMAIL_ADDRESS < $EMAIL_BODY' "
#eval $SSH_TO

mail -S smtp=lcc.localdomain -s 'Jupyter_Notebook_login_details'  $EMAIL_ADDRESS < $EMAIL_BODY

module load ccs/cuda/11.2.0_460.27.04

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ohpc/pub/utils/ccs/cuda/10.1.105/toolkit/targets/x86_64-linux/lib/

mkdir -p /scratch/$USER/jupyter.tmp

source activate $envnote

srun jupyter-notebook --no-browser --port=$ipnport --ip=$ipnip --notebook-dir=$homedir --NotebookApp.token=$tokenccs

