#!/bin/bash

#cd $1
#ls *.* > mylist;
#cat mylist
#echo 'done'

for files in -d $1
do {
	ls $files
	echo done
}
done

