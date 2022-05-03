#!/bin/bash

# $1, $2, $3 = (Dea, Lid, 21). $4 is the name of the atoms in considertion, $5 is the type of analysis e.g. hac, life, num
source /path/to/gromacs2020.2/bin/GMXRC
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

tags="O4-N8H-A-B O7-O4H-B-A N2-O4H-B-A O4H-O4H-A-A O7-N8H-B-B"
{ echo 'a O04 & 2'; echo 'a O07 & 3'; echo 'a O04 H0F & 2'; echo 'a N02 & 3'; echo 'a N08 & 3'; echo 'a N08 H0U & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx

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
