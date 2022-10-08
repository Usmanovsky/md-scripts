#!/bin/bash
# Don't forget to use absolute paths
# This copies files between the Lab GPUs and the LCC. This works when you're logged onto the lab gpu. LCC has no interactive feature
read -p 'Source: ' from
read -p 'Destination: ' to
read -p 'lab2lcc or lcc2lab or lab2xps? Pick one: ' mode


if [ $mode = 'lcc2lab' ]
then
	echo 'lcc2lab'
	scp -r ulab222@lcc.uky.edu:/scratch/ulab222/$from $to
elif [ $mode = 'lab2lcc' ]
then
	echo 'lab2lcc'
	scp -r $from ulab222@lcc.uky.edu:/scratch/ulab222/$to
elif [ $mode = 'lab2xps' ]
then
        echo 'lab2xps'
        scp -r ulab222@10.163.150.93:/data/ulab222/$from $to
else
	echo 'Please choose one of the appropriate options'
fi

if [ $?==0 ]
then
	echo 'Successfully copied!'
else
	echo 'Oops! Something went wrong there, I think.'
fi
