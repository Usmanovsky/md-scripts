#!/bin/bash
# created by ulab
# this script edits a template inp file for Orca jobs.
inp=$1
protein=$2
atoms=$3

sed -i "s/xxx/$protein/g" $inp
sed -i "s/num_atoms/$atoms/g" $inp
