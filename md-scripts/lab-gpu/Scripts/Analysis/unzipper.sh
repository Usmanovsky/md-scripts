#!/bin/bash
chmod 755 $0

# Say folder Usman contains two folders Ussy and Maryam and these two folders in turn 
# have zipped folders in them. Navigate to Usman first then call unzipper.sh and pass 
# "./" as a param to it. 

function unzipper(){
	for files in -d $1
do {
	list=`sudo ls -1 $files`
	echo $list
	for x in $list
	do {
		folder=`sudo ls -1 $x`
		unzip $x/$folder -d $x/

	}
done
	}
done

}

unzipper $1
