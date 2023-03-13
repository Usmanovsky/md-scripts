#!/bin/bash

#find $1 -type f | while read FILE
#do
#	mv $FILE $( echo $FILE | sed "s/hnum/hnum$2/g" )
#done


# $1 is the rdf directory containing the txt files. $2 is the number you want to append to the 
# rdf part of its name e.g. You can change tl11_rdf.txt to tl11-rdf1.txt

find $1 -name "*.txt" -type f | while read FILE
do
	echo $FILE
	mv $FILE $( echo $FILE | sed "s/_rdf/-rdf$2/g" )
done
