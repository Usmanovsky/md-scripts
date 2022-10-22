#!/bin/bash
# ulab 09/30/2022
# This calls dat-to-out.py to get secondary structure info from dat files
# and store it in out files.

dat_to_out () {
  dir=$1
  dat=${dir%.*}
  echo $dat
  python3 dat-to-out.py $dat
  }

export -f dat_to_out
find $1 -type f -name "AF*.pdb" | xargs -I {} -P 1000 bash -c 'dat_to_out  "$@"' _ {};
