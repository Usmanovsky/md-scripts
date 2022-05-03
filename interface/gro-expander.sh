#!/bin/bash
source /path/to/gromacs2020.2/bin/GMXRC

x=$4
y=$5
z=$6
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
i='_expanded'
s='_solvated'


gmx_gpu editconf -f $name$f.gro -o $name$i.gro -box $x $y $z -noc
gmx_gpu solvate -cp $name$i.gro  -cs tip4p.gro -o $name$s.gro