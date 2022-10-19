#!/bin/bash
# run dat-merger for all residues segregated by length
for x in {0..10}; do ./dat-merger.sh $x; done
