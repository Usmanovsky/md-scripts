#!/bin/bash
# Don't forget to use absolute paths
# This copies files between the Lab GPUs and the LCC
read -p 'Source: ' from
read -p 'Destination: ' to
read -p 'lab2lcc or lcc2lab? Pick one: ' mode


if [ $mode = 'lcc2lab' ]
then
	echo 'lcc2lab'
	scp -r -v $from ulab222@10.163.150.93:/path/to/$to
elif [ $mode = 'lab2lcc' ]
then
	echo 'lab2lcc'
	scp -r ulab222@10.163.150.93:/path/to/$from $to
else
	echo 'Please choose one of the appropriate options'
fi

if [ $?==0 ]
then
	echo 'Successfully copied!'
else
	echo 'Oops! Something went wrong there, I think.'
fi
