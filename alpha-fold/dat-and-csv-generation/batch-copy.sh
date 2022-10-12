#!/bin/bash
# Copy output-data-* to scratch
find $1 -name "output-*" -type d | xargs -I {} -P 1000 cp -r {} $2;
