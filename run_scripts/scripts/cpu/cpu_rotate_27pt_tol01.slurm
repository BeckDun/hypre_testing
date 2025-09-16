#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=256
#SBATCH --cpus-per-task=1
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=hypre_ij_rotate_27pt_tol01
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=0

module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1

module list


cd $HOME/hypre_testing/hypre/src/build/test

srun -n 256 ./ij  -solver 1 -rotate -27pt -n 256 256 256 -P 8 8 4 -eps 0.01 -alpha 45