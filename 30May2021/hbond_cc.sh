#!/bin/bash

# $1, $2, $3 = (Dea, Lid, 21). $4 is the name of the atoms in consideration (A=comp1, B=comp2), $5 is the type of analysis e.g. hac, life, num
#source /path/to/gromacs-2020.4/bin/GMXRC
source /path/to/gromacs2021.2/bin/GMXRC


name=$1-$2$3
one=1
two=2
three=3
c='_boxed'
d='dist'
ang='angle'
f='_md'
m='_msd'
r='_rdf'
h='hbond'
type1='hac'
l='hlife'
n='hnum'
mover(){
	mkdir $1
	mv *xvg ./$1
	mv *txt ./$1
        mv *$h.ndx ./$1
	mv $a*.log ./$1
}
mkdir 

tags="A-A A-B B-A B-B"
for x in $tags
do
	if [ "$x" == "A-A" ]
	then 
		{ echo 2; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
		a=$x
		{ echo 4; echo 4; echo q; } | gmx_gpu hbond -f $name$f.trr -s $name$f.tpr -n $name$h.ndx -ac $l-$name-$a.xvg -num $n-$name-$a.xvg -ang $ang-$name-$a.xvg -dist $d-$name-$a.xvg > $a-$name-$type1.log
		./unxvg2txt.sh '.'
		mover ./$h-$name-$a
		
	elif [ "$x" == "A-B" ]
	then 
		{ echo 2; echo 3; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
		a=$x
		{ echo 4; echo 5; echo q; } | gmx_gpu hbond -f $name$f.trr -s $name$f.tpr -n $name$h.ndx -ac $l-$name-$a.xvg -num $n-$name-$a.xvg -ang $ang-$name-$a.xvg -dist $d-$name-$a.xvg > $a-$name-$type1.log
		./unxvg2txt.sh '.'
		mover ./$h-$name-$a

		
	elif [ "$x" == "B-B" ]
	then
		{ echo 3; echo q; } | gmx_gpu make_ndx -f $name$c.gro -o $name$h.ndx
		a=$x
		{ echo 4; echo 4; echo q; } | gmx_gpu hbond -f $name$f.trr -s $name$f.tpr -n $name$h.ndx -ac $l-$name-$a.xvg -num $n-$name-$a.xvg -ang $ang-$name-$a.xvg -dist $d-$name-$a.xvg > $a-$name-$type1.log
		./unxvg2txt.sh '.'
		mover ./$h-$name-$a
		
	else 
		echo "Something is wrong."
		exit
	fi

done
