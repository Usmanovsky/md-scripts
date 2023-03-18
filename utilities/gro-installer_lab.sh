#!/bin/bash

file=$1
ext=.tar.gz

tar xfz $file$ext
cd $file
mkdir build
cd build

cmake .. -DGMX_MPI=OFF -DGMX_GPU=ON -DCMAKE_INSTALL_PREFIX=/path/to/$file -DBUILD_SHARED_LIBS=off -DGMX_DEFAULT_SUFFIX=OFF -DGMX_BINARY_SUFFIX=_gpu -DGMX_PREFER_STATIC_LIBS=ON -DGMX_BUILD_OWN_FFTW=ON -DGMX_FFT_LIBRARY=fftw3 -DGMX_USE_RDTSCP=ON 

make
make check
make install

