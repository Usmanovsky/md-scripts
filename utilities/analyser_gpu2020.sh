#!/bin/bash
#SBATCH  --partition=V4V16_SKY32M192_M
#SBATCH  --job-name=THY-LID21
#SBATCH --output=thy_lid21.out
#SBATCH  --time=24:00:00
#SBATCH  --mail-user=xxx@xxx
#SBATCH  --mail-type=ALL
#SBATCH -N 1 #No of nodes
#SBATCH -n 16 #No of cores
#SBATCH --gres=gpu:1 #no of gpu
#SBATCH --account=xxx #Account to run under

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load cmake
module load ccs/cuda/10.0.130

source /path/to/gromacs2020/bin/GMXRC
options_md="-ntmpi 8 -npme 4 -nb gpu"

a=$4

if [ $3 == 11 ]
then
	b=$a
elif [ $3 == 12 ]
then
	b=$(( $a * 2 ))
elif [ $3 == 21 ]
then
	b=$(( $a / 2 ))
else
	echo "I am lost"
	exit
fi

name=$1-$2$3
one=1
two=2
three=3
c='_boxed'
d='_em'
e='_npt'
f='_md'
m='_msd'
r='_rdf'

mover(){
	mkdir $1
	mv *xvg ./$1
}

# Making index files
if [ $2 == 'Lid' ]
then
	{ echo 'a C* & 2'; echo 'a O* & 2';  echo 'a H* & 2'; echo 'a C* & 3'; echo 'a O* & 3'; echo 'a H* & 3'; echo 'a N* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx
else
	{ echo 'a C* & 2'; echo 'a O* & 2';  echo 'a H* & 2'; echo 'a C* & 3'; echo 'a O* & 3'; echo 'a H* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx
fi

# EDR ananlysis
echo "10\n" | gmx_gpu energy -f $name$d.edr -o $name-energymin.xvg
echo "17\n" | gmx_gpu energy -f $name$e.edr -o $name-press.xvg
echo "23\n" | gmx_gpu energy -f $name$e.edr -o $name-density.xvg
mover edr

# MSD
{ echo 2; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$1.xvg

{ echo 3; } | gmx_gpu msd -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$m-$2.xvg
mover msd

# RDF
if [ $2 == 'Lid' ]
then
	{ echo 4; echo 7; echo 8; echo 9; echo 10; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$r.xvg

else
	{ echo 4; echo 7; echo 8; echo 9; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f traj_comp.xtc -s $name$f.tpr -o $name$r.xvg
fi
mover rdf
