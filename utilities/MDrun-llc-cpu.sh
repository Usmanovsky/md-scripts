#!/bin/bash

# V.Gazula 1/8/2019
 
#SBATCH -t 90:00:00   				#Time for the job to run 
#SBATCH --job-name=Z4P_ClO4		   	#Name of the job
#SBATCH -N 1 					#Number of nodes required
#SBATCH -n 32					#Number of cores needed for the job
#SBATCH --partition=SKY32M192_M			#Name of the queue

#SBATCH --mail-type ALL				#Send email on start/end
#SBATCH --mail-user qshao@uky.edu		#Where to send email

#SBATCH --account=xxx		#Name of account to run under


module purge
module load gnu/5.4.0
module load openmpi/1.10.7
module load ccs/gromacs/skylake/2019
source /opt/ohpc/pub/libs/gnu/openmpi/ccs/gromacs/2019/skylake/bin/GMXRC


echo "Job running on SLURM NODELIST: $SLURM_NODELIST " 

#GROMACS single node with 4 GPUs using thread-MPI and allow GROMACS to determine the launch parameters (ntmpi, ntomp) on it's own.
#gmx grompp -f pme.mdp
#gmx mdrun  -nsteps 4000 -v -pin on -nb gpu

options_md2="-ntmpi 8  -npme 4"
options_md=" -nice 1 -nb gpu -pme gpu -ntomp 8 -gpu_id 1"
options_mm=" -nice 1 -v -nb gpu -ntmpi 1 -ntomp 8 -gpu_id 1"
#options=" -nice 1 -nb gpu -ntomp 4 -ntmpi 3 -gputasks 001"
#options=" -nice 1 -ntomp 16"

a=1
#OMP_NUM_THREADS=8
for file in Z4P-ClO4
do
{
#for equlibrium
# end of equilibrium
#cd $file-test
for number in 2 3 
do
{
let num2=number+1
#node1=4
#node2=$((node1*(a-1)))
#a=$((a+1))
gmx grompp -f $file$number -c $file$number.gro -n $file.ndx -p $file.top -o $file$number.tpr -maxwarn 2
gmx mdrun -s $file$number -o $file$num2.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options_md2
#mpiexec -np $node1 -cpus-per-proc $OMP_NUM_THREADS $GROMACS/gmx_gpu mdrun -s $file$number -o $file$num2.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options

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
