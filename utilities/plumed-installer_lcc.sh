#!/bin/bash
module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
#module load fftw/3.3.8
module load cmake
#module load scalapack/2.0.2
#module load openblas/0.3.0
module load ccs/cuda/10.0.130

export CC=gcc
export CXX=g++
file=$1
ext='.tgz'

tar xfz $file$ext
cd $file
./configure --prefix=/path/to/plumed
make -j 4
make install
