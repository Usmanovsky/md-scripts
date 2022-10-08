#!/bin/bash
#SBATCH  --partition=SKY32M192_M
#SBATCH  --job-name=ChC-UreaMar27
#SBATCH --output=chcureaMar27.out
#SBATCH  --time=60:25:15
#SBATCH  --mail-user=ulab222@uky.edu
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 30 #No of cores
#SBATCH --account=col_qsh226_uksr #Account to run under

module purge
module load gnu/5.4.0
module load openmpi/1.10.7
module load ccs/gromacs/skylake/2019
module load ccs/anaconda/3

source /project/qsh226_uksr/gromacs-2020-CPU/gromacs-exe/bin/GMXRC
options_md="-ntmpi 8 -npme 4"

# This script runs a GROMACS md simulation
# $1 is the pdb file, $2 is the Energy minmisation mdp, $3 is the topology, 
# $4 is the NPT mdp, $5 is the production mdp

gmx pdb2gmx -f $1.pdb -o $1.gro -water none -ff oplsaa
echo 'Gro file produced'

# Putting the gro file into a box 
gmx editconf -f $1.gro -o $1_boxed.gro -c -d 0.2 -bt cubic
echo 'Gro file boxed'

# Energy minimization
gmx grompp -f $2.mdp -c $1_boxed.gro -p $3.top -o $1_em.tpr
echo 'EM grompp done'
gmx mdrun -v -s $1_em.tpr -o $1_em.trr -c $1_em.gro -e $1_em.edr -g $1_em.log $options_md
echo 'EM mdrun done'
echo "9\n" | gmx energy -f $1_em.edr -o energymin.xvg
echo 'EM plot done'

# NPT Equilibration
gmx grompp -f $4.mdp -c $1_em.gro -p $3.top -o $1_npt.tpr
echo 'NPT grompp done'
gmx mdrun -v -s $1_npt.tpr -o $1_npt.trr -c $1_npt.gro -e $1_npt.edr -g $1_npt.log $options_md
echo 'NPT mdrun done'
echo "16\n" | gmx energy -f $1_npt.edr -o $1_pressure.xvg
echo 'NPT pressure plot done'
echo "21\n" | gmx energy -f $1_npt.edr -o $1_density.xvg
echo 'NPT density plot done'

# Production run
gmx grompp -f $5.mdp -c $1_npt.gro -p $3.top -o $1_md.tpr
gmx mdrun -v -s $1_md -o $1_md.trr -c $1_md.gro -e $1_md.edr -g $1_md.log $options_md
echo 'MD done'
