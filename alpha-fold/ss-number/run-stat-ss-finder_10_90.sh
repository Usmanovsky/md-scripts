#!/bin/bash
# run stat-ss_10_90-finder.sh for all secondary structures segregated by length
for x in {0..10}; do ./stat-ss_10_90-finder.sh $x; done
