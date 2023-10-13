#!/bin/bash
# This launches sasa_analyzer.sh
# how to run (place script outside the protein folders): 
#         ./launch_sasa_analyzer.sh $1 $2 $3
# $1 is the name you want for your protein's region of interest
# $2 is the first residue number of the protein's region of interest
# $3 is the second residue number of the protein's region of interest
region=$1
res1=$2
res3=$3

for x in APOE2 APOE2-V254E APOE3 APOE3-R154S APOE4 APOE4-R269G; do cd ./$x; /path/to/myscripts-162/protein-md/sasa_analyzer.sh $x  $region $res1 $res2; cd ..; done
