#!/bin/bash
# Test to see if there are 50k pdb and 50k dssp files in each folder within a batch.
for x in {1..20}; do ~/myscripts/alpha-fold/v4-data-download/file_counter.sh folder-$x; done
