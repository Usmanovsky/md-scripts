#!/bin/bash

source /data/ulab222/gromacs2020.2/bin/GMXRC
#chmod 755 $0
b='_boxed'
r='rdf'
dl21='Dea-Lid21'
dm11='Dea-Men11'
dm12='Dea-Men12'
tl21='Thy-Lid21'
tl11='Thy-Lid11'
tm21='Thy-Men21'
tm11='Thy-Men11'
ml21='Men-Lid21'
f='_md'
read -p 'Pick one of dl21/dm11/dm12/tl21/tl11/tm21/tm11/ml21: ' des
p='_npt'
three='3'
num='2'

rdfbaba(){ 
	case $1 in
	dl21)
        { echo 'a O00 & 2'; echo 'a O07 & 3'; echo q; } | gmx_gpu make_ndx -f $dl21$b.gro -o $1-$r.ndx
	{ echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $dl21$f.trr -s $dl21$f.tpr -o $dl21$r-112.xvg
	{ echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $dl21$f.trr -s $dl21$f.tpr -o $dl21$r-22.xvg
	;;
	dm11)
        #gmx_gpu  grompp -f $dm11$three.mdp -c $dm11$p.gro -p $dm11.top -o $dm11$f$num.tpr
	{ echo 'a O02 & 2'; echo 'a O00 & 3'; echo q; } | gmx_gpu make_ndx -f $dm11$b.gro -o $1-$r.ndx
        { echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $dm11$f.trr -s $dm11$f.tpr -o $dm11$r-112.xvg
        { echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $dm11$f.trr -s $dm11$f.tpr -o $dm11$r-22.xvg
        ;;
	dm12)
        { echo 'a O02 & 2'; echo 'a O00 & 3'; echo q; } | gmx_gpu make_ndx -f $dm12$b.gro -o $1-$r.ndx
        { echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $dm12$f.trr -s $dm12$f.tpr -o $dm12$r-112.xvg
        { echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $dm12$f.trr -s $dm12$f.tpr -o $dm12$r-22.xvg
        ;;
	tl11)
        { echo 'a O04 & 2'; echo 'a O07 & 3'; echo q; } | gmx_gpu make_ndx -f $tl11$b.gro -o $1-$r.ndx
        { echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tl11$f.trr -s $tl11$f.tpr -o $tl11$r-112.xvg
        { echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tl11$f.trr -s $tl11$f.tpr -o $tl11$r-22.xvg
        ;;
	tl21)
        { echo 'a O04 & 2'; echo 'a O07 & 3'; echo q; } | gmx_gpu make_ndx -f $tl21$b.gro -o $1-$r.ndx
        { echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tl21$f.trr -s $tl21$f.tpr -o $tl21$r-112.xvg
        { echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tl21$f.trr -s $tl21$f.tpr -o $tl21$r-22.xvg
        ;;
	tm11)
        { echo 'a O04 & 2'; echo 'a O00 & 3'; echo q; } | gmx_gpu make_ndx -f $tm11$b.gro -o $1-$r.ndx
        { echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tm11$f.trr -s $tm11$f.tpr -o $tm11$r-112.xvg
        { echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tm11$f.trr -s $tm11$f.tpr -o $tm11$r-22.xvg
        ;;
	tm21)
        { echo 'a O04 & 2'; echo 'a O00 & 3'; echo q; } | gmx_gpu make_ndx -f $tm21$b.gro -o $1-$r.ndx
        { echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tm21$f.trr -s $tm21$f.tpr -o $tm21$r-112.xvg
        { echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $tm21$f.trr -s $tm21$f.tpr -o $tm21$r-22.xvg
        ;;
	ml21)
        { echo 'a O00 & 2'; echo 'a O07 & 3'; echo q; } | gmx_gpu make_ndx -f $ml21$b.gro -o $1-$r.ndx
        { echo 4; echo 4; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $ml21$f.trr -s $ml21$f.tpr -o $ml21$r-112.xvg
        { echo 5; echo 5; exec 0<&-; } | gmx_gpu rdf -n $1-$r.ndx -f $ml21$f.trr -s $ml21$f.tpr -o $ml21$r-22.xvg
        ;;
esac
}

rdfbaba $des
python3 ../../scr*//xvg*.py *12.xvg
python3 ../../scr*/xvg*.py *22.xvg
mkdir rdfbaba
mv *2.xvg *f.ndx *txt rdfbaba/
echo Job Done!
