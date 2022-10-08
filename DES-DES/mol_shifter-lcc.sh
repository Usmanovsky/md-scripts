#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=DES-DES
#SBATCH --output=Jun2021.out
#SBATCH  --time=0:02:00
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 8 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=gol_qsh226_uksr #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130
module load ccs/conda/python-3.8.0

source /project/qsh226_uksr/DES_usman/gromacs2021.2/bin/GMXRC

# This script shifts molecules in a box along the z axis. $4 is the length to shift.
# This assumes all your files are in the same working directory.

name=$1-$2$3
new_name=$1$2$3
one=1
two=2
three=3
f='_md'
i='interface'
w='water'
s='_shifted'

mover(){
        mkdir $1
        mv *gro ./$1
        mv *.log ./$1
}


gmx_gpu editconf -f $name.gro -o $new_name.gro -translate 0 0 $4  > $new_name$s.log
