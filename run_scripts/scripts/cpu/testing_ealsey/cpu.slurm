#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --partition=l40s
#SBATCH --gpus-per-node=1       # Allocate 1 GPU so CUDA can initialize
#SBATCH --time=00:10:00
#SBATCH --job-name=hypre_cpu
#SBATCH --output=cpu32_solver1.out

# Hide the GPU from the application after initialization
export CUDA_VISIBLE_DEVICES=""
export OPENMPI_GPU_SUPPORT_ENABLED=0

cd $HOME/hypre_testing/src/build/test

# Force CPU execution with explicit flags
srun -n 32 ./ij -solver 1 -125pt -n 128 128 128 -P 4 4 2 \
    -memory_host -exec_host -exec2_host -memory_location 0 -exec_policy 0
