#!/bin/bash
# run csv-merger for all secondary structures segregated by length
for x in {0..10}; do ./csv-merger.sh $x; done
