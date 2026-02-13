#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=256
#SBATCH --cpus-per-task=1
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=hypre_ij_array
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=1


export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1


cd $HOME/hypre_testing/src/build/test

srun -n 256 -G 1 ./ij -solver 1 -125pt -n 128 128 128 -P 8 8 4 -memory_host -exec_host
