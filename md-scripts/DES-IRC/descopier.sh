#!/bin/bash

find './' -type d -name '[^o]*' | while read FILE
do
	cp launcher.sh $FILE
	cp des_irc.py $FILE
	cp md.sh $FILE
done
