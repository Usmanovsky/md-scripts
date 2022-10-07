#!/bin/bash

find $1/*.xvg -type f | while read FILE
do
	python3 /data/ulab222/script/xvg2dat.py $FILE
done
