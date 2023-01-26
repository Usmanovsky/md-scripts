#!/bin/bash
# run stat-res_10_90-finder.sh for all residues segregated by length
# and generate boxplot files.
for x in {0..10}; do ./stat-res_10_90-finder.sh $x; done
