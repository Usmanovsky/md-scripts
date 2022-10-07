#!/bin/bash

# This script moves the content of an xvg file into a similarly named text file without the comments and the @s. 

find $1 \( -name "a*xvg" \) -type f | while read FILE
do
	echo $FILE
	tail -30 "$FILE" > "${FILE%.xvg}.txt"
done
