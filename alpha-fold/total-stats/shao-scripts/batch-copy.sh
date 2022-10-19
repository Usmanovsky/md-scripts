#!/bin/bash
# Copy output-data-* to scratch
find . -name "output-*" -type d | xargs -I {} -P 1000 cp -r {} $scratch/alpha-fold/new-batches/$1/;
