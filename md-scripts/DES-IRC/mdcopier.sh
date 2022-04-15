#!/bin/bash

find './' -type d -name '[^o]*' | while read FILE
do
	cp md.sh $FILE
done
