#!/bin/bash

find './' -type d -name '[o]*' | while read FILE
do
	cp $1 $FILE
done
