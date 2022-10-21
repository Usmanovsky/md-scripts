#!/bin/bash
# This finds *.out files with errors (letters in the PLDDT column)
# how-to-run: ./error-sniffer.sh name-of-out-folder >> name-of-log-file-to-store-results
# If you do not pass a name, the default is output-data-*
# This assumes the script is in the same directory as the output-data-* folders.

t="./output-data-*"
target=${1:-$t}
find $target -type f -name "AF*.out" | xargs -I {} -P 1000 grep -l ' C ~' {};
