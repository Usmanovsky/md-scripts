#!/bin/bash

# This script runs an interactive node on the LCC. $1 is the time in the format 00:00:00
t=05:30:00
g=CAC48M192_L
c=36
cpu=${3:-$g}
timee=${1:-$t}
cores=${2:-$c}
srun -A xxx -t $timee -N 1 -n 1 -c $cores -p $cpu --pty bash
