#!/bin/bash

file=$1
ext='.tar.gz'

tar xfz $file$ext
cd $file
./configure --prefix=/path/to
make -j 4
make install
