#!/bin/bash

# This script loops through all the DES folders in the working directory
# and submits the simulation job.
dir=`pwd`
find $dir -name '[^o]*'  -type d | while read FILE
do
	cd $FILE
	ls
	./inserter.sh $1 $2 11 50 6.0 0.2
		
done
