#!/bin/bash

find $1 -type f -name '*.xvg' | while read FILE
do
	python3 ~/myscr*/xvg2txtconverter.py $FILE
done
