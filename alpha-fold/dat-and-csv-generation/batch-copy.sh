#!/bin/bash
# Copy output-data-* to scratch
find $1 -name "AF-*dssp" -type f | xargs -I {} -P 1000 cp -r {} $2;
