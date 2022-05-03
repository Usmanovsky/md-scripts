#!/bin/bash

# $1, $2, $3 = (Dea, Lid, 21). $4 is the name of the atoms in considertion, $5 is the type of analysis e.g. hac, life, num
source /path/to/gromacs2020.2/bin/GMXRC
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
h='hbond'
type1='hac'
type2='hlife'

mover(){
	mkdir $1
	mv *xvg ./$1
	mv *txt ./$1
	mv $a*.log ./$1
}

{echo 'a O02 & 2'; echo 'a O07 & 3'; echo 'a O02 H0C & 2'; echo 'a O00 & 2'; echo 'a N08 & 3'; echo 'a N08 H0U & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
gmx_gpu hbond -f traj_comp.xtc -s $name$f.tpr -n $name$h.ndx -ac $name-$a.xvg -num hnum-$a.xvg > $a-$name-$type1.log
#gmx_gpu hbond -f traj_comp.xtc -s $name$f.tpr -n $name$h.ndx -life $type2-$a.xvg -num $type2-$a-hnum.xvg  > $a-$type2.log

python3 ../../script/xvg2dat.py $name-$a.xvg
python3 ../../script/xvg2dat.py hnum-$a.xvg
#python3 ../../script/xvg2dat.py $type2-$a.xvg
#python3 ../../script/xvg2dat.py $type2-$a-hnum.xvg
mover hbond-$name-$a
