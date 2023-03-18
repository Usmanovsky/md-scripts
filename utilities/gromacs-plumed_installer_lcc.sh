#! /bin/bash
#module load gcc/4.9.1
#module load intel/2018.2.199
#module load mpi/openmpi/gcc/1.8.2
#module load cuda/7.0
#module swap intel gnu8/8.2.0
#module swap impi openmpi3
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
#export CC_GPU=gcc
#export CFLAGS="-xHost -O3 -no-prec-div"
#export CXXFLAGS=" -xHost -O3 -no-prec-div"
file=$1
ext=.tar.gz
echo $file$ext
p="_plumed"
tar xfz $file$ext
cd $file
mkdir build
cd build

cmake .. -DGMX_MPI=OFF -DGMX_GPU=CUDA -DGMX_SIMD=AVX2_256 -DCMAKE_INSTALL_PREFIX=/path/to/$file$p -DBUILD_SHARED_LIBS=off -DGMX_DEFAULT_SUFFIX=OFF -DGMX_BINARY_SUFFIX=_gpu -DGMX_PREFER_STATIC_LIBS=ON -DGMX_BUILD_OWN_FFTW=ON -DGMX_FFT_LIBRARY=fftw3 -DGMX_USE_RDTSCP=ON -DGMXAPI=OFF 

make
make check
make install
