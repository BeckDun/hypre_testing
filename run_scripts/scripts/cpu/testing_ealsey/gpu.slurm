#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --partition=l40s
#SBATCH --gpus-per-node=3
#SBATCH --time=00:10:00
#SBATCH --job-name=hypre_gpu
#SBATCH --output=gpu_solver0_128_test.out

cd $HOME/hypre_testing/src/build/test

srun -n 3 -G 3 ./ij -solver 0 -125pt -n 128 128 128 -P 3 1 1 \
    -memory_device -exec_device -exec2_device
