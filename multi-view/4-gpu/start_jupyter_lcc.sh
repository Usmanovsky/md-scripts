#!/bin/bash

#Written by ULAB 3/30/2022
#SBATCH --partition=V4V32_CAS40M192_L                   #Name of the partition
#SBATCH --job-name DeepChem-jupyter-notebook                    #Nameof the job
#SBATCH --output jupyter-notebook-%j-8Nov2022.log                #Output file name
#SBATCH --account=xxx                       #SLurm Account
#SBATCH --ntasks=40                                     #Number of cores
#SBATCH --gres=gpu:4                                    #Number of GPU's needed
#SBATCH --mail-type ALL
#SBATCH --mail-user xxx@xxx                     #Email to forward
#SBATCH --time=72:00:00                                 #Time required for the Jupyter job


## get tunneling info
XDG_RUNTIME_DIR=""
ipnport=$(shuf -i8000-9999 -n1)
ipnip=$(hostname -i)

user=$(whoami)
tokenccs=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1)


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
    "  > jupyter.creds-$SLURM_JOB_ID-$DATE.out

EMAIL_ADDRESS=$(cat /home/$USER/.forward)
EMAIL_BODY=$PWD/jupyter.creds-%j-$DATE.out
#SSH_TO="ssh $USER@lcc.ccs.uky.edu ' mail -s 'Jupiter_Notebook_login_details' $EMAIL_ADDRESS < $EMAIL_BODY' "
#eval $SSH_TO

mail -S smtp=lcc.localdomain -s 'Jupyter_Notebook_login_details'  $EMAIL_ADDRESS < $EMAIL_BODY
#CONTAINER=/share/singularity/images/ccs/conda/lcc-conda-1-rocky8.sinf

#module load ccs/singularity
module load ccs/cuda/11.2.0_460.27.04
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ohpc/pub/utils/ccs/cuda/10.1.115/toolkit/targets/x86_64-linux/lib/
mkdir -p /scratch/$USER/jupyter.tmp
source activate /home/ulab222/.conda/envs/sklearn
srun jupyter-notebook --no-browser --port=$ipnport --ip=$ipnip --notebook-dir=/scratch/ --NotebookApp.token=$tokenccs

#srun singularity run --app deepchem250gpu --nv -B $HOME/.local-dc:$HOME/.local -B /scratch/$USER/jupyter.tmp:/tf -B /scratch/$USER/jupyter.tmp:/run/notebook $CONTAINER jupyter-notebook --notebook-dir=/scratch/$USER  --no-browser --port=$ipnport --ip=$ipnip --NotebookApp.token=$tokenccs
