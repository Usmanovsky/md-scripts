#!/bin/bash
# check if number of residues and secondary structures matches.
if [ "$(wc -l < $1)" -eq "$(wc -l < $2)" ]; then echo "Match between $1 and $2!"; else echo "Warning: No Match between $1 and $2!"; fi
