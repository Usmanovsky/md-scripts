#!/bin/bash

find './' -type d -name '[h]*' | while read FILE
do
	cp -r $FILE $1
done
