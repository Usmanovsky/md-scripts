#!/bin/bash

# This renames all the files and folders in the current directory to block names

for file in * ; do      
	echo $file
    mv $file ${file^^}
done