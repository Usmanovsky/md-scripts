#!/bin/bash
chmod 755 $0

read -p 'LCC or DellGPU? Type L or D: ' pc
read -p 'File path source: ' filefrom
read -p 'File path destination: ' fileto
read -sp 'pword: ' p

if [ $pc == 'L' ]
then
	scp -r ulab222@lcc.uky.edu:$filefrom $fileto
	echo Success! 
else
	scp -r ulab222@10.163.150.93:/data/ulab222/$filefrom $fileto
	echo Success!
fi
