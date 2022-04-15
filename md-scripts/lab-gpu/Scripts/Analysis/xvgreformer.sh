#!/bin/bash
chmod 755 $0

function xvgreformer(){
	for files in -d $1
do {
	list=`{ echo gunnaZZ90@!; } | sudo ls -1 $files`
	#echo $list
	#echo $files
	for x in $list 
	do {
		python3 $2 $files/$x
		echo $x
	}
done
	}
done

}

xvgreformer $1/edr xvg*.py
xvgreformer $1/rdf xvg*.py
xvgreformer $1/msd xvg*.py

xvgreformer $2/edr xvg*.py
xvgreformer $2/rdf xvg*.py
xvgreformer $2/msd xvg*.py

xvgreformer $3/edr xvg*.py
xvgreformer $3/rdf xvg*.py
xvgreformer $3/msd xvg*.py

xvgreformer $4/edr xvg*.py
xvgreformer $4/rdf xvg*.py
xvgreformer $4/msd xvg*.py

echo Done


