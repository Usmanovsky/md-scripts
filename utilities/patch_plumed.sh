#!/bin/bash

file=$1
#ext='.tar.gz'
#tar xfz $file$ext
cd $file
#mkdir build
cd build
plumed --no-mpi patch -p

cmake .. -DGMX_MPI=OFF -DGMX_GPU=CUDA -DCMAKE_INSTALL_PREFIX=/path/to/$file -DBUILD_SHARED_LIBS=off -DGMX_DEFAULT_SUFFIX=OFF -DGMX_BINARY_SUFFIX=_gpu -DGMX_PREFER_STATIC_LIBS=ON -DGMX_BUILD_OWN_FFTW=ON -DGMX_FFT_LIBRARY=fftw3 -DGMX_USE_RDTSCP=ON -DGMXAPI=OFF -DCMAKE_CXX_COMPILER=/usr/local/bin/g++ -DCMAKE_C_COMPILER=/usr/local/bin/gcc

make
make check
make install

