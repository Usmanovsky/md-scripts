#!/bin/bash
# This copies scripts from my home fodler to wherever they're needed. Change teh source
# and target paths as needed.
for x in ./batch-*; do cp ~/myscripts/alpha-fold/ss-number/mk* $x/ss-number/; cp ~/myscripts/alpha-fold/res-number/mk* $x/res-number/; done
