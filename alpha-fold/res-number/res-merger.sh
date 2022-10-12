#!/bin/bash
# This script finds all .out files, counts their lines (as a proxy for number of residues),
# and groups the protein info according to the range they fall in. This last part is done by
# append-residues.py

appender () {
  x=`wc -l $1`; lines=($x);  line=${lines[0]};
  line_no=$(( line / 100 ))
  dir=$1 
  if (( $line_no>10 ))
  then
    line_no=10
  fi

  python3 append-residues.py $dir $line_no
  #echo $1 $line_no
}

export -f appender
find $1 -type f -name "AF*.out" | xargs -I {} -P 1000 bash -c 'appender  "$@"' _ {};

