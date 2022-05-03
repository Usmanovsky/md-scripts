#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=shiftedNeutralPET_6.5_7.0
#SBATCH --output=neutralPET_3Nov2021.out
#SBATCH  --time=2:10:00
#SBATCH  --mail-user=xxx@xxx
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 10 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=xxx #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130

source /path/to/gromacs2021.2/bin/GMXRC
options_md="-ntmpi 1 -ntomp 10 -nb gpu -pme gpu"

# This script is for water systems with plastic. It runs a GROMACS md simulation using LibParGen files
# $1 is the name of the plastic gro file e.g PET
# $name$c is the solvated gro file, $one is the Energy minimization mdp,
# $two is the NPT mdp, $three is the production mdp
# example:  sbatch ./md2021_pet*.sh PET WAT 1 7.0 7.5
# $4 is the x,y length and $5 is the z length of the box.

name=$1-$2
one=1
two=2
three=3
c='_boxed'
d='_em'
e='_npt'
f='_md'
m='_msd'
r='_rdf'
n="_numbered"
g="_centered"
i='_index'
p='posre_'
s='_shifted'
npt='semiiso'

mover(){
        mkdir $1
        mv *xvg ./$1
}

# create restraint file for non-Hydrogen atoms in PET
{ echo "0 & !a H*"; echo q; } | gmx_gpu make_ndx -f $1.gro -o $1$i.ndx
{ echo 3; } | gmx_gpu genrestr -f $1.gro -n $1$i.ndx -o $p$1.itp -fc 1000 1000 1000

gmx_gpu insert-molecules -ci $1.gro -o $name.gro -nmol $3 -box 1.0
gmx_gpu editconf -f $name.gro -o $name$g.gro -box $4 $4 $5 -c  # center the PET mol in a bigger box
gmx_gpu editconf -f $name$g.gro -o $name$s.gro -translate 0 0 -1.0  # shift it to the left by 1nm
gmx_gpu solvate -cp $name$s.gro  -cs tip4p.gro -o $name$c.gro -p $name.top

# Energy minimization
gmx_gpu  grompp -f $one.mdp -c $name$c.gro  -r $name$c.gro -p $name.top -o $name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -deffnm $name$d
echo 'EM mdrun done'

# NPT Equilibration
gmx_gpu  grompp -f $npt.mdp -c $name$d.gro -p $name.top -r $name$d.gro -o $name$e.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -deffnm $name$e $options_md
echo 'NPT mdrun done'


# Production run
gmx_gpu  grompp -f $three.mdp -c $name$e.gro -p $name.top -o $name$f.tpr
gmx_gpu mdrun -deffnm $name$f $options_md
#gmx_gpu convert-tpr -s $name$f.tpr -nsteps 100000000 -o $name$f$two.tpr
#gmx_gpu mdrun -v -s $name$f$two -o $name$f.trr -c $name$f.gro -e $name$f.edr -g $name$f.log $options_md -cpi state.cpt
echo 'MD done'

#plumed --no-mpi sum_hills --hills HILLS
