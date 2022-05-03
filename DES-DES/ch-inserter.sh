#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=CHO-URE12
#SBATCH --output=CHO-URE12-1Jul2021.out
#SBATCH  --time=40:05:00
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
module load ccs/conda/python-3.8.0

source /path/to/gromacs2021.2/bin/GMXRC
# This script inserts 3 compounds ($1, $2, $3) into a box for DES-DES simulations.
# $4 is molar ratio, $5 is number of molsA, $6 is box length, $7 is radius between
# molecules.

#source /path/to/gromacs-2021.2/bin/GMXRC
options_md="-ntmpi 1 -ntomp 10 -nb gpu -pme gpu -update gpu"

a=$5

if [ $4 == 11 ]
then
	b=$a
elif [ $4 == 12 ]
then
	b=$(( $a * 2 ))
elif [ $4 == 21 ]
then
	b=$(( $a / 2 ))
else
	echo "I am lost"
	exit
fi

name=$1-$2$4
one=1
two=2
three=3
num=50
cc='_box'
c='_boxed'
d='_em'
e='_npt'
f='_md'
m='_msd'
r='_rdf'

mover(){
	mkdir $1
	mv *xvg ./$1
        mv *txt ./$1
        mv *log ./$1
}

scriptpath=~/myscr*
# Putting the gro file into a box 
gmx_gpu insert-molecules -ci $1.gro -o $name.gro -nmol $a -box $6 -radius $7
gmx_gpu insert-molecules -ci $2.gro -f $name.gro -o $name$cc.gro -nmol $b
gmx_gpu insert-molecules -ci $3.gro -f $name$cc.gro -o $name$c.gro -nmol $a
echo 'Gro file boxed'

# Putting the gro file into a box
#gmx_gpu editconf -f $name$n.gro -o $name$c.gro -c -bt cubic
#echo 'Gro file boxed'

# Energy minimization
gmx_gpu  grompp -f $one.mdp -c $name$c.gro -p $name.top -o $name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -s $name$d.tpr -o $name$d.trr -c $name$d.gro -e $name$d.edr -g $name$d.log
echo 'EM mdrun done'

# NPT Equilibration
gmx_gpu  grompp -f $two.mdp -c $name$d.gro -p $name.top -o $name$e.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -s $name$e.tpr -o $name$e.trr -c $name$e.gro -e $name$e.edr -g $name$e.log $options_md
echo 'NPT mdrun done'

# Production run
gmx_gpu  grompp -f $three.mdp -c $name$e.gro -p $name.top -o $name$f.tpr
gmx_gpu mdrun -s $name$f -o $name$f.trr -c $name$f.gro -e $name$f.edr -g $name$f.log $options_md
#gmx_gpu convert-tpr -s $name$f.tpr -nsteps 100000000 -o $name$f$two.tpr
#gmx_gpu mdrun -v -s $name$f$two -o $name$f.trr -c $name$f.gro -e $name$f.edr -g $name$f.log $options_md -cpi state.cpt
echo 'MD done'

# Make ndx
gmx_gpu make_ndx -f $name$c.gro -o $name.ndx

# EDR ananlysis
echo "10\n" | gmx_gpu energy -f $name$d.edr -o $name-energymin.xvg
echo "17\n" | gmx_gpu energy -f $name$e.edr -o $name-press.xvg
echo "23\n" | gmx_gpu energy -f $name$e.edr -o $name-density.xvg
mover $name-edr

{ echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx
{ echo 2; echo 2; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $1-density.xvg -relative -sl $num > $1-density.log
{ echo 3; echo 3; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $2-density.xvg -relative -sl $num > $2-density.log
{ echo 4; echo 4; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $3-density.xvg -relative -sl $num > $3-density.log
{ echo 0; echo 0; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name.ndx  -o $name-density.xvg -relative -sl $num > $name-density.log

mover density-$name
cd density-$name
$scriptpath/unxvg2txt.sh '*'
