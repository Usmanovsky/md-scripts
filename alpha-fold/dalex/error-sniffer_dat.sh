#!/bin/bash
# This finds *.out files with errors (letters in the PLDDT column)
# how-to-run: ./error-sniffer.sh name-of-out-folder >> name-of-log-file-to-store-results
# If you do not pass a name, the default is output-data-*
# This assumes the script is in the same directory as the output-data-* folders.

t="./output-data-*"
n="AF*.out"
target=${1:-$t}
name=${2:-$n}
find $target -type f -name $name | xargs -I {} -P 1000 grep -l ' C ~' {};
