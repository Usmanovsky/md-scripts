#!/bin/bash
# This script runs a GROMACS md simulation

source /usr/local/gromacs/bin/GMXRC

gmx pdb2gmx -f $1.pdb -o $1.gro -water none
echo 'Gro file produced'

