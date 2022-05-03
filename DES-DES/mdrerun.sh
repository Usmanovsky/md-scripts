#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=rerun-DES-DES
#SBATCH --output=rerun-dm11_tl11-5Jun2021.out
#SBATCH  --time=40:05:00
#SBATCH  --mail-user=xxx@xxx
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 8 #No of cores
#SBATCH --gres=gpu:1 #No of GPUs
#SBATCH --account=xxx #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130

source /path/to/gromacs2021.2/bin/GMXRC
options_md="-ntmpi 1 -ntomp 8 -nb gpu -pme gpu -update gpu"

# This script is for DES-DES systems. It runs a GROMACS md simulation using LibParGen files
# $1 is the name of the merged gro file e.g ThyLid11-MenLid11
# $name$c is the boxed gro file, $one is the Energy minimization mdp,
# $two is the NPT mdp, $three is the production mdp

name=$1
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

mover(){
	mkdir $1
	mv *xvg ./$1
}

# Re-numbering the atoms in the merged box
#gmx_gpu editconf -f $name.gro -o $name$n.gro -resnr 1

# Putting the gro file into a box 
#gmx_gpu editconf -f $name$n.gro -o $name$c.gro -c -d 0.5 -bt cubic
#echo 'Gro file boxed'

# Energy minimization
#gmx_gpu  grompp -f $one.mdp -c $name$c.gro -p $name.top -o $name$d.tpr
#echo 'EM grompp done'
#gmx_gpu mdrun -s $name$d.tpr -o $name$d.trr -c $name$d.gro -e $name$d.edr -g $name$d.log
#echo 'EM mdrun done'

# NPT Equilibration
#gmx_gpu  grompp -f $two.mdp -c $name$d.gro -p $name.top -o $name$e.tpr
#echo 'NPT grompp done'
#gmx_gpu mdrun -s $name$e.tpr -o $name$e.trr -c $name$e.gro -e $name$e.edr -g $name$e.log $options_md
#echo 'NPT mdrun done'

# Production run
#gmx_gpu  grompp -f $three.mdp -c $name$e.gro -p $name.top -o $name$f.tpr
#gmx_gpu mdrun -s $name$f -o $name$f.trr -c $name$f.gro -e $name$f.edr -g $name$f.log $options_md
gmx_gpu convert-tpr -s $name$f.tpr -nsteps 100000000 -o $name$f$two.tpr
gmx_gpu mdrun -v -s $name$f$two -o $name$f.trr -c $name$f.gro -e $name$f.edr -g $name$f.log $options_md -cpi state.cpt
echo 'MD done'
#

# Making index files
{ echo 'a O* & 2'; echo 'a O* & 3'; echo 'a O* & 4'; echo 'a O* & 5'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx

# EDR ananlysis
echo "10\n" | gmx_gpu energy -f $name$d.edr -o $name-energymin.xvg
echo "17\n" | gmx_gpu energy -f $name$e.edr -o $name-press.xvg
echo "23\n" | gmx_gpu energy -f $name$e.edr -o $name-density.xvg
mover edr

# MSD
#{ echo 2; } | gmx_gpu msd -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$m-$1.xvg

#{ echo 3; } | gmx_gpu msd -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$m-$2.xvg

#{ echo 4; } | gmx_gpu msd -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$m-$w.xvg
#mover msd

# RDF
#{ echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$r-112.xvg
#{ echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$r-22.xvg
#mover rdf
