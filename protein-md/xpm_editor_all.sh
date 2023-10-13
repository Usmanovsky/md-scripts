#!/bin/bash
# created bu ulab 10/10/2023
# this is the same as xpm_editor.sh but it automates calling it over all my proteins of interest
res1=$1
res2=$2
for x in APOE2 APOE3 APOE4 APOE4-R269G APOE3-R154S APOE2-V254E; do /path/to/myscripts-162/protein-md/xpm_editor.sh $x $res1 $res2; done
