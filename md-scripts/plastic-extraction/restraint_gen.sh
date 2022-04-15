#!/bin/bash


#gro_name=$1
#itp_name=$2
{ echo 0; } | gmx_gpu genrestr -f $1.gro -o $2.itp -fc 1000 1000 1000
