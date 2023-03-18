#!/bin/bash
# Copy to/fro Google drive using rclone. 
#Don't forget to use absolute paths
# switch to dtn mode first: ssh dtn.ccs.uky.edu
reader(){
        read -p 'Source: ' from
        read -p 'Destination: ' to
}

PS3='Please enter your choice: '
options=("copy google-drive to lcc" "copy lcc to google-drive" "sync lcc to google-drive" "sync google-drive to lcc" "dryrun: sync google-drive to lcc" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            echo "you chose $opt"
            reader
            rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s ulabgdrive:$from $to            
            ;;
        "${options[1]}")
            echo "you chose $opt"
            reader
            rclone copy --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s $from ulabgdrive:$to
            ;;
        "${options[2]}")
            echo "you chose $opt"
            reader
            rclone sync --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s ulabgdrive:$from $to
            ;;
        "${options[3]}")
            echo "you chose $opt"
            reader
            rclone sync --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s $from ulabgdrive:$to
            ;;
        "${options[4]}")
            echo "you chose $opt"
            reader
            rclone sync --dry-run --update --verbose --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s $from ulabgdrive:$to
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

