#!/bin/bash

# This script runs an interactive node on the LCC. $1 is the time in the format 00:00:00
t=05:30:00
g=V4V32_CAS40M192_L #V4V32_CAS40M192_L
c=36
gpu=${3:-$g}
timee=${1:-$t}
cores=${2:-$c}
srun -A xxx -t $timee --gres=gpu:1 -N 1 -n 1 -c $cores -p $gpu --pty bash
#V4V32_CAS40M192_L
