#!/bin/bash

source /path/to/gromacs2021.2/bin/GMXRC
#source /path/to/gromacs-2021.2/bin/GMXRC

# This script rescales a box along the x and y axis. $4 and $5 are 
# the rescaling factors in x and y axis respectively.
# This assumes all your files are in the same working directory.
options_md="-ntmpi 1 -ntomp 8 -nb gpu -pme gpu -update gpu"
name=$1-$2$3
new_name=$1$2$3
one=1
two=2
three=3
i='interface'
w='water'
s='_shifted'
c='_boxed'
d='_em'
e='_npt'
f='_md'
m='_msd'
r='_rescaled'
n="_numbered"
npt='semiiso'
mover(){
        mkdir $1
        mv *gro ./$1
        mv *.log ./$1
}


gmx_gpu editconf -f $name$f.gro -o $new_name$r.gro -scale $4 $5 1 > $new_name$r.log
# Re-numbering the atoms in the merged box
#gmx_gpu editconf -f $new_name.gro -o $new_name$n.gro -resnr 1

# Putting the gro file into a box 
gmx_gpu editconf -f $new_name$r.gro -o $new_name$c.gro -bt cubic
echo 'Gro file boxed'

# Energy minimization
gmx_gpu  grompp -f $one.mdp -c $new_name$c.gro -p $name.top -o $new_name$d.tpr
echo 'EM grompp done'
gmx_gpu mdrun -s $new_name$d.tpr -o $new_name$d.trr -c $new_name$d.gro -e $new_name$d.edr -g $new_name$d.log
echo 'EM mdrun done'

# NPT Equilibration
gmx_gpu  grompp -f $npt.mdp -c $new_name$d.gro -p $name.top -o $new_name$e.tpr
echo 'NPT grompp done'
gmx_gpu mdrun -s $new_name$e.tpr -o $new_name$e.trr -c $name.gro -e $new_name$e.edr -g $new_name$e.log $options_md
echo 'NPT mdrun done'
