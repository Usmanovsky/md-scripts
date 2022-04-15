#!/bin/bash

find './' -type f -name '*.png' | while read FILE
do
	convert $FILE $( echo $FILE | sed "s/png/tiff/g" )
done
