#!/bin/bash
source /data/ulab222/gromacs-2020.4/bin/GMXRC

#ML21

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
x='_density'
w='water'
o2='O02'
o0='O00'
o7='O07'
c='C'

mover(){
        mkdir $1
        mv *xvg ./$1
        mv *txt ./$1
        mv *density.log ./$1
}


{ echo 'a O00 & 2'; echo 'a C* & 2'; echo 'a O07 & 3'; echo 'a C* & 3'; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$x.ndx
{ echo 2; echo 2; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name$x.ndx  -o $1-density.xvg -relative > $1-density.log
{ echo 3; echo 3; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name$x.ndx  -o $2-density.xvg -relative > $2-density.log
{ echo 4; echo 4; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name$x.ndx  -o $w-density.xvg -relative > $w-density.log
{ echo 7; echo 7; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name$x.ndx  -o $o0-$1-density.xvg -relative > $oo-$1-density.log
{ echo 8; echo 8; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name$x.ndx  -o $c-$1-density.xvg -relative > $c-$1-density.log
{ echo 9; echo 9; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name$x.ndx  -o $o7-$2-density.xvg -relative > $o7-$2-density.log
{ echo 10; echo 10; } | gmx_gpu density -f $name$f.trr  -s $name$f.tpr  -n $name$x.ndx  -o $c-$2-density.xvg -relative > $c-$2-density.log

python3 /data/ulab222/script/xvg2dat.py $1-density.xvg
python3 /data/ulab222/script/xvg2dat.py $2-density.xvg
python3 /data/ulab222/script/xvg2dat.py $w-density.xvg
python3 /data/ulab222/script/xvg2dat.py $o0-$1-density.xvg
python3 /data/ulab222/script/xvg2dat.py $c-$1-density.xvg
python3 /data/ulab222/script/xvg2dat.py $o7-$2-density.xvg
python3 /data/ulab222/script/xvg2dat.py $c-$2-density.xvg

mover densities-$name

