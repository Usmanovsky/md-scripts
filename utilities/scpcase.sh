#!/bin/bash

# This script copies files between the LCC and Lab GPUs. We could use Filezilla too.

reader(){
	read -p 'Source: ' from
	read -p 'Destination: ' to
}

PS3='Please enter your choice: '
options=("lcc to mydesk93" "lcc to behind-my-desk176" "lcc to shaodesk162" "lcc to shaodesk88" "mydesk93 to lcc" "behind-my-desk176 to lcc" "shaodesk162 to lcc" "shaodesk88 to lcc" "lcc to here" "here to lcc" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            echo "you chose $opt"
            reader
            scp -r -v $from ulab222@10.163.150.93:/path/to/$to            
            ;;
        "${options[1]}")
            echo "you chose $opt"
            reader
            scp -r -v $from ulab222@10.163.149.176:$to
            ;;
        "${options[2]}")
            echo "you chose $opt"
            reader
            scp -r -v $from ulab222@10.163.150.162:/path/to/$to
            ;;
        "${options[3]}")
            echo "you chose $opt"
            reader
            scp -r -v $from ulab222@10.163.150.88:/path/to/$to
            ;;
        "${options[4]}")
            echo "you chose $opt"
            reader
            scp -r ulab222@10.163.150.93:/path/to/$from $to
            ;;
        "${options[5]}")
            echo "you chose $opt"
            reader
            scp -r ulab222@10.163.149.176:$from $to
            ;;
        "${options[6]}")
            echo "you chose $opt"
            reader
            scp -r ulab222@10.163.150.162:/path/to/$from $to
            ;;
        "${options[7]}")
            echo "you chose $opt"
            reader
            scp -r ulab222@10.163.150.88:/path/to/$from $to
            ;;
        "${options[8]}")
            echo "you chose $opt"
            reader
            scp -r ulab222@lcc.uky.edu:$from $to
            ;;
        "${options[9]}")
            echo "you chose $opt"
            reader
            scp -r $from ulab222@lcc.uky.edu:$to
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
