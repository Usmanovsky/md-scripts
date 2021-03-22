#!/bin/bash
# This script converts xvg to txt files using xvg2dat.py

find */*xvg | while read FILE
do	
	python3 xvg2dat.py $FILE
	echo $FILE
done

