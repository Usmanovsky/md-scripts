#!/bin/bash
# Move output-data-* to scratch
find $1 -maxdepth 1 -name "AF*.$2" -type f | xargs -I {} -P 1000 mv {} $3;
