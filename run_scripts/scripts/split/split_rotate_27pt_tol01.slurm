#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=pcg_cpu_gpu_rotate
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=4

# Load required modules
module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1

echo "Loaded modules:"
module list

# Navigate to the test directory
cd $HOME/hypre_testing/src/build/test

srun --cpu-bind=cores --gpu-bind=closest \
     -n 4 -G 4 \
     ./ij \
    -solver 1 \
    -rotate 0.01 \
    -27pt \
    -n 256 256 256 \
    -P 2 2 1 \
    -setup_host_solve_device