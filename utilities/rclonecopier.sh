#!/bin/bash
# Don't forget to use absolute paths
#ssh dtn.ccs.uky.edu
read -p 'Source: ' from
read -p 'Destination: ' to
read -p 'google2lcc or lcc2google? Pick one: ' mode


if [ $mode = 'lcc2google' ]
then
	echo 'lcc2google'
	rclone copy $from ulabgdrive:$to
elif [ $mode = 'google2lcc' ]
then
	echo 'google2lcc'
	rclone copy ulabgdrive:$from $to
else
	echo 'Please choose one of the appropriate options'
fi

if [ $?==0 ]
then
	echo 'Successfully copied!'
else
	echo 'Oops! Something went wrong there, I think.'
fi
