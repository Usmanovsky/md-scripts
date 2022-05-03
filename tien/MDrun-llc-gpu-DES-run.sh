#!/bin/bash

module purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load ccs/cuda/10.0.130
#module load ccs/gromacs/skylake-gpu/2019
source /path/to/gromacs2020/bin/GMXRC

#GROMACS single node with 4 GPUs using thread-MPI and allow GROMACS to determine the launch parameters (ntmpi, ntomp) on it's own.
#gmx grompp -f pme.mdp
#gmx mdrun  -nsteps 4000 -v -pin on -nb gpu

options_md2=" -nice 1 -nb gpu -ntmpi 1 -ntomp 8 -gpu_id 0"
options_md=" -nice 1 -nb gpu -ntmpi 1 -ntomp 8 -gpu_id 0"
#options=" -nice 1 -nb gpu -ntomp 4 -ntmpi 3 -gputasks 001"
#options=" -nice 1 -ntomp 16"

a=1
OMP_NUM_THREADS=8
for file in Z3-EO5-TFSI
do
{
#for equlibrium
# end of equilibrium
#cd $file-test


for number in 2 3 4
do
{
let num2=number+1
gmx_gpu grompp -f $file$number -c $file$number.gro -p $file.top -n $file.ndx -o $file$number.tpr -maxwarn 2

gmx_gpu mdrun -s $file$number -o $file$number.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options_md

#for resume
#gmx_gpu mdrun -s $file$number -o $file$number.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options_md -cpi state.cpt
}
done

}
done

# Run on a single node with 4 GPUs, 4 OMP threads/rank, 8 ranks, 2 MPI ranks per GPU using thread-MPI
#gmx grompp -f pme.mdp
#gmx mdrun -ntmpi 8 -ntomp 4  -nsteps 4000 -v -pin on -nb gpu

#Run on 2 nodes with 4 GPUs/node, 2 OMP threads/rank, 16 ranks per node, 4 MPI ranks per GPU using CUDA MPS to allow multiple MPI ranks per GPU:
#gmx grompp -f pme.mdp
#OMP_NUM_THREADS=2 mpirun -np 32 gmx_mpi mdrun -nb gpu -nsteps 8000 -v -pin on
