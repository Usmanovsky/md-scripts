#!/bin/bash
source /data/ulab222/gromacs2020.2/bin/GMXRC

echo "10\n" | gmx_gpu energy -f *em.edr -o $1-energymin.xvg
echo "17\n" | gmx_gpu energy -f *npt.edr -o $1-press.xvg
echo "23\n" | gmx_gpu energy -f *npt.edr -o $1-density.xvg

mkdir newxvg
mv *xvg newxvg
