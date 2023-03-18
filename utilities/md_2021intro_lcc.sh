#!/bin/bash
#SBATCH  --partition=V4V32_CAS40M192_L
#SBATCH  --job-name=dm11-plasticfodler
#SBATCH --output=dm11_12Oct2021.out
#SBATCH  --time=35:00:00
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
options_md="-ntmpi 1 -ntomp 10 -update gpu -nb gpu"

# This script works on the LCC. It runs a GROMACS md simulation using LibParGen files
# $1 and $2 are the gro files,$3 is the molar ratio, $4 is the no of moles of A,
# $5 is the box size and $6 is the radius between molecules of A
# $name$c is the boxed gro file, $name$d is the Energy minimization mdp,
# $name$e is the NPT mdp, $name$f is the production mdp

# how to run on LCC: sbatch ./md_2021_intro.sh Dea Men 11 100 6.5 0.2

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
elif [ $3 == 31 ]
then
        b=$(( $a / 3 ))
elif [ $3 == 41 ]
then
        b=$(( $a / 4 ))
elif [ $3 == 51 ]
then
        b=$(( $a / 5 ))
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
t='traj'
o='oxygen'
w='whole'
h='hbond'
type1='hac'
dd='dist'
ang='angle'
l='hlife'
n='hnum'

mover(){
	mkdir $1
	mv *xvg ./$1
	mv *txt ./$1
    mv *$h.ndx ./$1
	mv $a*.log ./$1
}

echo "Job $SLURM_JOB_ID running on SLURM NODELIST: $SLURM_NODELIST"
# Putting the gro file into a box 
gmx_gpu insert-molecules -ci $1.gro -o $name.gro -nmol $a -box $5 -radius $6
gmx_gpu insert-molecules -ci $2.gro -f $name.gro -o $name$c.gro -nmol $b
echo 'Gro file boxed'

# Energy minimization
gmx_gpu  grompp -f $name$one.mdp -c $name$c.gro -p $name.top -o $name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -deffnm $name$d
echo 'EM mdrun done'

# NPT Equilibration
gmx_gpu  grompp -f $name$two.mdp -c $name$d.gro -p $name.top -o $name$e.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -deffnm $name$e $options_md
echo 'NPT mdrun done'

# Production run
gmx_gpu  grompp -f $name$three.mdp -c $name$e.gro -p $name.top -o $name$f.tpr
gmx_gpu mdrun -deffnm $name$f $options_md
echo 'MD done'


# Making index files
{ echo 'a O* & 2'; echo 'a O* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name.ndx

# EDR ananlysis
echo "10\n" | gmx_gpu energy -f $name$d.edr -o $name-energymin.xvg
echo "17\n" | gmx_gpu energy -f $name$e.edr -o $name-press.xvg
echo "23\n" | gmx_gpu energy -f $name$e.edr -o $name-density.xvg
mover edr

# MSD
{ echo 2; } | gmx_gpu msd -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$m-$1.xvg

{ echo 3; } | gmx_gpu msd -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$m-$2.xvg
mover msd

# RDF
{ echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$r-112.xvg
{ echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $name.ndx -f $name$f.trr -s $name$f.tpr -o $name$r-22.xvg
mover rdf

# Trajectory
{ echo 2; echo q; } | gmx_gpu traj -n $name.ndx -f $name$f.trr -s $name$f.tpr -ox $1-$t.xvg
{ echo 3; echo q; } | gmx_gpu traj -n $name.ndx -f $name$f.trr -s $name$f.tpr -ox $2-$t.xvg
mover $name-$t-$w

{ echo 4; echo q; } | gmx_gpu traj -n $name.ndx -f $name$f.trr -s $name$f.tpr -ox $1-$o$t.xvg
{ echo 5; echo q; } | gmx_gpu traj -n $name.ndx -f $name$f.trr -s $name$f.tpr -ox $2-$o$t.xvg
mover $name-$t-$o


tags="A-A A-B B-B"
for x in $tags
do
	if [ "$x" == "A-A" ]
	then 
		{ echo 2; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
		tag=$x
		{ echo 4; echo 4; echo q; } | gmx_gpu hbond -f $name$f.trr -s $name$f.tpr -n $name$h.ndx -ac $l-$name-$tag.xvg -num $n-$name-$tag.xvg -ang $ang-$name-$tag.xvg -dist $dd-$name-$tag.xvg > $tag-$name-$type1.log		
		mover ./$h-$name-$tag
                #./unxvg2txt.sh '*'
		
	elif [ "$x" == "A-B" ]
	then 
		{ echo 2; echo 3; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
		tag=$x
		{ echo 4; echo 5; echo q; } |  gmx_gpu hbond -f $name$f.trr -s $name$f.tpr -n $name$h.ndx -ac $l-$name-$tag.xvg -num $n-$name-$tag.xvg -ang $ang-$name-$tag.xvg -dist $dd-$name-$tag.xvg > $tag-$name-$type1.log		
		mover ./$h-$name-$tag
                #./unxvg2txt.sh '*'
	
	elif [ "$x" == "B-B" ]
	then
		{ echo 3; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
		tag=$x
		{ echo 4; echo 4; echo q; } |  gmx_gpu hbond -f $name$f.trr -s $name$f.tpr -n $name$h.ndx -ac $l-$name-$tag.xvg -num $n-$name-$tag.xvg -ang $ang-$name-$tag.xvg -dist $dd-$name-$tag.xvg > $tag-$name-$type1.log
		mover ./$h-$name-$tag
                ./unxvg2txt.sh '*'
		
	else 
		echo "Something is wrong."
		exit
	fi

done
