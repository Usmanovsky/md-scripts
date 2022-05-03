#!/bin/bash

find $1 -type f -name '*.xvg' | while read FILE
do
	python3 /path/to/Scripts/Analysis/xvg2txtconverter.py $FILE
done
