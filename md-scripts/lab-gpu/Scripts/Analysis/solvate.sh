#!/bin/bash
source /data/ulab222/gromacs2020.2/bin/GMXRC

x=$4
y=$x
#z=$(( 2 * $4 ))
z=$(echo 2*$x | bc)
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
i='_int4p'
s='solvated'

#echo $x $y $z
gmx_gpu editconf -f $name$f.gro -o $name$i.gro -box $x $y $z -noc
gmx_gpu solvate -cp $name$i.gro  -cs tip4p.gro -o $name-$s.gro

#3.76579 3.76579 7.53158
