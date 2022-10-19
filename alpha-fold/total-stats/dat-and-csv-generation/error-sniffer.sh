#!/bin/bash
# This finds *.out files with errors (letters in the PLDDT column)
# how-to-run: ./error-sniffer.sh >> name-of-log-file-to-store-results
# This assumes the script is in the same directory as  th eoutput-data-* folders.

find ./output-data-* -type f -name "AF*.out" | xargs -I {} -P 1000 grep -l ' C ~' {};
