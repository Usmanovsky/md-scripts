#!/bin/bash

# $1, $2, $3 = (Dea, Lid, 21). $4 is the name of the atoms in considertion, $5 is the type of analysis e.g. hac, life, num
source /data/ulab222/gromacs2020.2/bin/GMXRC
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

{ echo 'a O02 & 2'; echo 'a O00 & 3'; echo 'a O02 H0C & 2'; echo 'a O00 H0E & 3'; echo 'a O00 & 2'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
tags="O0H-O0H-B-B O0-O0H-A-B O0-O2H-A-A O0-O2H-B-A O2H-O2H-A-A O2-O0H-A-B"
for x in $tags
do
        a=$x
        gmx_gpu hbond -f $name$f.trr -s $name$f.tpr -n $name$h.ndx -ac $name-$a.xvg -num hnum-$a.xvg -ang ang-$a.xvg -dist dist-$a.xvg > $a-$name-$type1.log
        python3 /data/u*/script/xvg2dat.py $name-$a.xvg
        python3 /data/u*/script/xvg2dat.py hnum-$a.xvg
        python3 /data/u*/script/xvg2dat.py dist-$a.xvg
        python3 /data/u*/script/xvg2dat.py ang-$a.xvg
        mover hbond-$name-$a
done
