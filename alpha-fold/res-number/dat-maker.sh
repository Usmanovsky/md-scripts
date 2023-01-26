#!/bin/bash

find . -maxdepth 1 -mindepth 1 -type d | while read dir; do
  echo "$dir"
  cd $dir
  touch ALA.dat ARG.dat ASN.dat ASP.dat CYS.dat GLU.dat GLN.dat GLY.dat HIS.dat ILE.dat LEU.dat LYS.dat MET.dat PHE.dat PRO.dat SER.dat THR.dat TRP.dat TYR.dat VAL.dat
  cd .. 
done
